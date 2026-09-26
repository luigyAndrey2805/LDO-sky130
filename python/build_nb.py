# ==============================================================================
# Encabezado: Generator Script for OTA_caracterizacion.ipynb
# Descripción: Escribe y pre-ejecuta el notebook OTA_caracterizacion.ipynb
#              eliminando la simulación transitoria e incorporando VGS, VDS, Vth, 
#              Vdsat, el margen (VDS - Vdsat) y la región de operación.
# ==============================================================================

import nbformat as nbf
import subprocess
import os

nb = nbf.v4.new_notebook()

# 1. Documentación Markdown
md_cell = nbf.v4.new_markdown_cell("""# Caracterización de Punto de Operación (.OP) y Respuesta AC de la OTA (Sky130)
---
Este notebook realiza la caracterización del Amplificador Operacional de Transconductancia (**OTA**) definido en `OTA_tb.sch`:

1. **Análisis en Frecuencia (Respuesta AC):**
   - Extracción de **Ganancia DC ($A_{v0}$)**, **Ancho de Banda a -3dB ($f_{-3dB}$)**, **Frecuencia de Ganancia Unitaria ($GBW$)** y **Margen de Fase ($PM$)**.
   - Diagrama de Bode Interactivo (Magnitud y Fase) con `plotly.graph_objects`.

2. **Tabla de Punto de Operación (.OP) y Verificación de Región:**
   - Extracción de parámetros de polarización y pequeña señal para los 8 transistores del OTA (`Mnr`, `Mpr`, `Mo`, `Mn`, `Mp`, `Mr`, `Mrc1`, `Mc2`):
     - Corriente de Drenador ($I_D$), Transconductancia ($g_m$), Conductancia de Drenador ($g_{ds}$), Resistencia de Salida ($r_o$), Ganancia Intrínseca ($g_m r_o$).
     - Tensiones de Polarización: $|V_{GS}|$, $|V_{DS}|$, $|V_{th}|$, $|V_{dsat}|$.
     - **Margen de Saturación:** $|V_{DS}| - |V_{dsat}|$ (Permite verificar si $|V_{DS}| \\ge |V_{dsat}|$).
     - **Región de Operación:** Clasificación explícita en **Saturación**, **Triodo** o **Débil Inversión (Weak Inversion)**.
""")

# 2. Celda 1: Simulación AC y Diagrama de Bode
code_cell1 = nbf.v4.new_code_cell("""# ==============================================================================
# Encabezado: Simulación AC y Generación de Diagrama de Bode
# Descripción: Ejecuta la simulación AC en NGspice, extrae métricas de ganancia,
#              ancho de banda y margen de fase, y grafica el diagrama de Bode.
# ==============================================================================

import subprocess
import os
import numpy as np
np.complex_ = complex  # Parche de compatibilidad para spyci con NumPy 2.0
from spyci import spyci
import plotly.graph_objects as go
from plotly.subplots import make_subplots

# ── 1. Re-simulación Automática con xschem y NGspice ──────────────────────────
sch_file = "../xschem/OTA_tb.sch"
if not os.path.exists(sch_file):
    sch_file = "/foss/designs/LDO-sky130/xschem/OTA_tb.sch"

xschem_dir = os.path.dirname(os.path.abspath(sch_file))

# Re-generar netlist OTA_tb.spice desde el esquemático
subprocess.run(f"export PDK=sky130A && /foss/tools/bin/xschem -n -q -o {xschem_dir} {sch_file}", shell=True)

# Ejecutar simulación NGspice para regenerar OTA_ac.raw y OTA_op.raw
subprocess.run(f"cd {xschem_dir} && /foss/tools/bin/ngspice -b OTA_tb.spice", shell=True)

# ── 2. Carga de Datos de Simulación AC con spyci ─────────────────────────────
raw_ac_file = os.path.join(xschem_dir, "OTA_ac.raw")

ac_data = spyci.load_raw(raw_ac_file)
raw_ac_vals = ac_data['values']

freq = np.real(raw_ac_vals['frequency'])
vo_complex = raw_ac_vals['v(vo)']

mag_db = 20 * np.log10(np.abs(vo_complex))
phase_deg = np.angle(vo_complex, deg=True)
phase_deg = np.unwrap(np.radians(phase_deg)) * (180.0 / np.pi)

# ── 2. Cálculo de Métricas de Desempeño AC ───────────────────────────────────
av0_db = mag_db[0]
av0_lin = 10**(av0_db / 20.0)

idx_3db = np.where(mag_db <= (av0_db - 3.0))[0]
f_3db = freq[idx_3db[0]] if len(idx_3db) > 0 else np.nan

idx_gbw = np.where(mag_db <= 0.0)[0]
if len(idx_gbw) > 0:
    f_gbw = freq[idx_gbw[0]]
    ph_at_gbw = phase_deg[idx_gbw[0]]
    # Margen de fase respecto a -180 grados de desfase
    pm = 180.0 + (ph_at_gbw % 360.0 if ph_at_gbw < 0 else ph_at_gbw)
    if pm > 180.0:
        pm -= 360.0
else:
    f_gbw = np.nan
    pm = np.nan

print("=== RESULTADOS DE CARACTERIZACIÓN AC ===")
print(f"Ganancia en DC (Av0):           {av0_db:.2f} dB ({av0_lin:.2f} V/V)")
print(f"Frecuencia de Corte (-3dB):    {f_3db/1e3:.2f} kHz")
print(f"Ancho de Banda GBW (0 dB):     {f_gbw/1e6:.2f} MHz")
print(f"Margen de Fase (PM):           {pm:.2f}°")

# ── 3. Generación de Diagrama de Bode con Plotly ─────────────────────────────
fig = make_subplots(rows=2, cols=1, shared_xaxes=True,
                    vertical_spacing=0.1,
                    subplot_titles=("Respuesta en Magnitud [dB]", "Respuesta en Fase [grados]"))

fig.add_trace(go.Scatter(x=freq, y=mag_db, mode='lines', name='Magnitud [dB]',
                         line=dict(color='#1f77b4', width=2.5)), row=1, col=1)

if not np.isnan(f_gbw):
    fig.add_trace(go.Scatter(x=[f_gbw], y=[0], mode='markers+text', name='GBW',
                             text=[f'GBW: {f_gbw/1e6:.2f} MHz'], textposition='top right',
                             marker=dict(size=10, color='green', symbol='star')), row=1, col=1)

fig.add_trace(go.Scatter(x=freq, y=phase_deg, mode='lines', name='Fase [°]',
                         line=dict(color='#d62728', width=2.5)), row=2, col=1)

fig.update_xaxes(type="log", row=1, col=1)
fig.update_xaxes(type="log", title_text="Frecuencia [Hz]", row=2, col=1)
fig.update_yaxes(title_text="Magnitud [dB]", row=1, col=1)
fig.update_yaxes(title_text="Fase [°]", row=2, col=1)

fig.update_layout(height=700, title_text="<b>Diagrama de Bode - Respuesta en Frecuencia de la OTA</b>",
                  template="plotly_white", showlegend=True)
fig.show()""")

# 3. Celda 2: Extracción de Tabla OP con VGS, VDS, Vdsat y Región
code_cell2 = nbf.v4.new_code_cell("""# ==============================================================================
# Encabezado: Extracción de Tabla de Punto de Operación (.OP) de la OTA
# Descripción: Extrae parámetros de polarización (VGS, VDS, Vth, Vdsat), 
#              criterios de inversión (Δov = Vgs - Vth) y saturación (Δvd = Vds - Vdsat),
#              parámetros de pequeña señal (gm, gds, ro, gm*ro) y clasifica la región 
#              de operación para todos los 8 transistores de la OTA.
# ==============================================================================

import pandas as pd
import numpy as np

raw_op_file = "../xschem/OTA_op.raw"
if not os.path.exists(raw_op_file):
    raw_op_file = "/foss/designs/LDO-sky130/xschem/OTA_op.raw"

op_data = spyci.load_raw(raw_op_file)
raw_vals = op_data['values']

transistores_ota = [
    ('Mnr (PMOS Mirror L)', 'pfet_01v8', 'xmnr'),
    ('Mpr (PMOS Mirror R)', 'pfet_01v8', 'xmpr'),
    ('Mo  (PMOS Output)',   'pfet_01v8', 'xmo'),
    ('Mn  (NMOS Diff L)',   'nfet_01v8', 'xmn'),
    ('Mp  (NMOS Diff R)',   'nfet_01v8', 'xmp'),
    ('Mr  (NMOS Ref)',      'nfet_01v8', 'xmr'),
    ('Mrc1(NMOS Tail)',     'nfet_01v8', 'xmrc1'),
    ('Mc2 (NMOS Output)',   'nfet_01v8', 'xmc2'),
]

def get_val(raw_vals, inst, modelo, param, is_func=False, func_name='v'):
    inst_lower = inst.lower()
    if is_func:
        k = f'{func_name}(@m.x1.{inst_lower}.msky130_fd_pr__{modelo}[{param}])'
    else:
        k = f'@m.x1.{inst_lower}.msky130_fd_pr__{modelo}[{param}]'
        
    if k in raw_vals.dtype.names:
        val = raw_vals[k]
        return float(np.abs(val[0])) if hasattr(val, '__len__') else float(np.abs(val))
    return np.nan

filas_op = []

for titulo, modelo, inst in transistores_ota:
    gm     = get_val(raw_vals, inst, modelo, 'gm') * 1e6
    gds    = get_val(raw_vals, inst, modelo, 'gds') * 1e6
    id_val = get_val(raw_vals, inst, modelo, 'id', is_func=True, func_name='i') * 1e6
    vgs    = get_val(raw_vals, inst, modelo, 'vgs', is_func=True, func_name='v')
    vds    = get_val(raw_vals, inst, modelo, 'vds', is_func=True, func_name='v')
    vth    = get_val(raw_vals, inst, modelo, 'vth', is_func=True, func_name='v')
    vdsat  = get_val(raw_vals, inst, modelo, 'vdsat', is_func=True, func_name='v')
    
    delta_ov = vgs - vth
    delta_vd = vds - vdsat
    
    # Manejo de transistores apagados (Id < 0.01 uA) para evitar inconsistencias de redondeo (0.00 uS * ro != 132.61 V/V)
    if id_val < 0.01:
        gm = 0.0
        gds = 0.0
        ro = np.nan
        gm_ro = 0.0
        inv_class = 'Apagado (Off)'
    else:
        ro = (1.0 / (gds * 1e-6)) / 1e3 if gds > 0 else np.nan
        gm_ro = (gm * 1e-6) * (ro * 1e3) if not np.isnan(ro) else np.nan
        inv_class = 'Inversión Débil' if delta_ov < 0 else ('Inversión Moderada' if delta_ov <= 0.1 else 'Inversión Fuerte')
        
    sat_class = 'Saturación' if delta_vd > 0 else 'Triodo'
        
    filas_op.append({
        'Transistor': titulo,
        'Id [uA]': round(id_val, 2),
        'gm [uS]': round(gm, 2),
        'gds [uS]': round(gds, 2),
        'ro [kOhm]': round(ro, 2) if not np.isnan(ro) else 'N/A',
        'gm*ro [V/V]': round(gm_ro, 2),
        '|VGS| [V]': round(vgs, 3),
        '|VDS| [V]': round(vds, 3),
        '|Vth| [V]': round(vth, 3),
        '|Vdsat| [V]': round(vdsat, 3),
        'Δov = Vgs-Vth [V]': round(delta_ov, 3),
        'Δvd = Vds-Vdsat [V]': round(delta_vd, 3),
        'Inversión': inv_class,
        'Región': sat_class
    })

df_op = pd.DataFrame(filas_op)
print("=== TABLA DE PUNTO DE OPERACIÓN (.OP) Y CRITERIOS DE OPERACIÓN DE LA OTA ===")
display(df_op)""")

# 4. Celda 3: Estimación y Desglose de Área en Silicio de la OTA
code_cell3 = nbf.v4.new_code_cell("""# ==============================================================================
# Encabezado: Estimación y Desglose de Área en Silicio de la OTA (Sky130)
# Descripción: Calcula el área física estimada ocupada por todos los transistores MOS,
#              la resistencia de compensación R1 y el capacitor de compensación MIM C1,
#              evaluando el porcentaje de área y el área total estimada de layout.
# ==============================================================================

import pandas as pd
import numpy as np
import plotly.graph_objects as go

# ── 1. Geometría de Componentes del Esquema OTA.sch ───────────────────────────
componentes = [
    # Transistores MOS: (Nombre, Tipo, W [um], L [um], nf, mult)
    ('Mr (NMOS Ref)',            'Transistor MOS',   0.5, 0.5, 1, 1),
    ('Mo (PMOS Output)',         'Transistor MOS',  20.0, 0.5, 1, 1),
    ('Mrc1 (NMOS Tail)',         'Transistor MOS',   2.0, 0.5, 1, 1),
    ('Mc2 (NMOS Output)',        'Transistor MOS',   1.0, 0.5, 1, 1),
    ('Mn (NMOS Diff L)',         'Transistor MOS',  40.0, 0.5, 1, 1),
    ('Mp (NMOS Diff R)',         'Transistor MOS',  40.0, 0.5, 1, 1),
    ('Mpr (PMOS Mirror R)',      'Transistor MOS',  40.0, 0.5, 1, 1),
    ('Mnr (PMOS Mirror L)',      'Transistor MOS',  40.0, 0.5, 1, 1),
    # Resistencia de compensación: R1 (res_high_po)
    ('R1 (Resistencia Poly High)', 'Resistencia Poly', 2.65, 2.65, 1, 1),
    # Capacitor de compensación: C1 (cap_mim_m3_2)
    ('C1 (Capacitor MIM M3-M4)',   'Capacitor MIM',   50.0, 50.0, 1, 1)
]

# Extensión física de difusiones S/D y guardrings por lado (um)
lsd_extension = 0.58 * 2

filas_area = []
area_mos_sum = 0.0
area_r1_sum = 0.0
area_c1_sum = 0.0

for nom, tipo, w, l, nf, mult in componentes:
    if tipo == 'Transistor MOS':
        area_silicon = w * (l + lsd_extension) * mult
        area_mos_sum += area_silicon
    elif tipo == 'Resistencia Poly':
        # Extensión de cabezales y contactos de resistor (1.0 um por borde)
        area_silicon = (w + 2.0) * (l + 2.0) * mult
        area_r1_sum += area_silicon
    elif tipo == 'Capacitor MIM':
        # Margen de anillo de guardring alrededor de placa MIM (2.0 um por borde)
        area_silicon = (w + 4.0) * (l + 4.0) * mult
        area_c1_sum += area_silicon

    filas_area.append({
        'Componente': nom,
        'Tipo': tipo,
        'W [um]': w,
        'L [um]': l,
        'nf': nf,
        'mult': mult,
        'Área Componente [um²]': round(area_silicon, 2)
    })

df_area = pd.DataFrame(filas_area)
area_bruta = area_mos_sum + area_r1_sum + area_c1_sum
factor_overhead = 1.25  # Factor 1.25x (25% overhead por interconexiones, n-well taps y guardrings)
area_estimada_layout = area_bruta * factor_overhead

print("=== DESGLOSE DE ÁREA FÍSICA ESTIMADA DE LA OTA (Sky130) ===")
display(df_area)

print("\\n=== RESUMEN GLOBAL DE ÁREA ===")
print(f"• Área Transistores MOS (8 inst):  {area_mos_sum:8.2f} um²  ({area_mos_sum/area_bruta*100:5.1f}%)")
print(f"• Área Resistencia Poly R1:        {area_r1_sum:8.2f} um²  ({area_r1_sum/area_bruta*100:5.1f}%)")
print(f"• Área Capacitor MIM C1:           {area_c1_sum:8.2f} um²  ({area_c1_sum/area_bruta*100:5.1f}%)")
print(f"-------------------------------------------------------------")
print(f"• Área Bruta Componentes:          {area_bruta:8.2f} um²")
print(f"• Área Estimada de Layout (1.25x):  {area_estimada_layout:8.2f} um²  ({area_estimada_layout/1e6:.6f} mm²)")
print(f"• Dimensión Cuadrada Equivalente:   {np.sqrt(area_estimada_layout):.1f} um x {np.sqrt(area_estimada_layout):.1f} um")

# ── 2. Gráfico Circular (Pie Chart) de Distribución de Área con Plotly ─────────
fig_pie = go.Figure(data=[go.Pie(
    labels=['Capacitor MIM C1', 'Transistores MOS', 'Resistencia Poly R1'],
    values=[area_c1_sum, area_mos_sum, area_r1_sum],
    hole=.3,
    marker_colors=['#1f77b4', '#2ca02c', '#ff7f0e'],
    textinfo='label+percent+value',
    texttemplate='%{label}<br>%{value:.1f} um² (%{percent})'
)])

fig_pie.update_layout(
    title_text="<b>Distribución Porcentual del Área en Silicio del OTA</b>",
    template="plotly_white",
    height=450
)
fig_pie.show()""")

nb.cells = [md_cell, code_cell1, code_cell2, code_cell3]

notebook_path = "/foss/designs/LDO-sky130/python/OTA_caracterizacion.ipynb"
with open(notebook_path, "w", encoding="utf-8") as f:
    nbf.write(nb, f)

print("Notebook generado correctamente en:", notebook_path)
