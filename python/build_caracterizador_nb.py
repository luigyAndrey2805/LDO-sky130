# ==============================================================================
# Encabezado: Generador del Notebook de Caracterización de Transistores (Untitled.ipynb)
# Descripción: Crea y pre-ejecuta Untitled.ipynb agregando capacitancia total (Cgg_total, Cgs_total)
#              y gráfica de corriente total (Id_total) para todos los fingers y multiplicidad.
# ==============================================================================

import nbformat as nbf
import subprocess
import os

nb = nbf.v4.new_notebook()

# 1. Documentación Markdown
md_cell = nbf.v4.new_markdown_cell("""# Caracterización Interactiva y Extracción .OP de Transistores Sky130
---
Este notebook permite **modificar dinámicamente los parámetros de simulación ($V_{GS}, V_{SG}, W, L, \\text{nf}, \\text{mult}$) directamente desde Python**, actualizar el netlist de SPICE, **ejecutar la simulación en NGspice**, extraer la **Tabla de Punto de Operación (.OP)** de los 4 transistores (`Mplvt`, `Mp`, `Mnlvt`, `Mn`) incluyendo geometría completa ($W, L, \\text{nf}, \\text{mult}$), **Corriente Total ($I_{D,\\text{total}}$)** y **Capacitancias Totales ($C_{gg,\\text{total}}, C_{gs,\\text{total}}$)** considerando todos los fingers y multiplicidad, y visualizar las **Curvas de Caracterización Analógica Interactivas con Plotly**.
""")

# 2. Celda 1: Parámetros y Simulación
code_cell1 = nbf.v4.new_code_cell("""# ==============================================================================
# Encabezado: Modificación Dinámica del Netlist, Simulación en NGspice y Carga (spyci)
# Descripción: Permite definir tensiones (VSG, VGS), dimensiones (W, L), fingers (nf) 
#              y multiplicidad (mult) desde Python, actualiza las instancias del netlist, 
#              ejecuta NGspice y carga el archivo .raw usando spyci.
# ==============================================================================

import os
import re
import subprocess
import numpy as np
np.complex_ = np.complex128  # Compatibilidad para spyci con NumPy 2.0
from spyci import spyci

# ── 1. Parámetros Configurables desde Python ──────────────────────────────────
VSG_TARGET = 0.6  # Tensión VSG objetivo para evaluar PMOS [V]
VGS_TARGET = 1.0  # Tensión VGS objetivo para evaluar NMOS [V]

# Dimensiones geométricas, dedos (nf) y multiplicidad (mult)
W_MPLVT = 1000; L_MPLVT = 0.35; NF_MPLVT = 50; MULT_MPLVT = 5
W_MP    = 1.0;  L_MP    = 0.15; NF_MP    = 1;  MULT_MP    = 1
W_MNLVT = 1.0;  L_MNLVT = 0.35; NF_MNLVT = 1;  MULT_MNLVT = 1
W_MN    = 0.3;  L_MN    = 0.50; NF_MN    = 1;  MULT_MN    = 1

# Rangos de barrido DC para Vgp (PMOS) y Vgn (NMOS)
VGP_START, VGP_STOP, VGP_STEP = 0.0, 1.8, 0.01
VGN_START, VGN_STOP, VGN_STEP = 0.0, 1.8, 0.01

# ── 2. Lectura y Modificación del Netlist SPICE ──────────────────────────────
BASE_NETLIST = '../xschem/caracterizador.spice'
SIM_NETLIST  = '../xschem/caracterizador_sim.spice'
RAW_FILE     = '../xschem/caracterizador.raw'

with open(BASE_NETLIST, 'r') as f:
    spice_content = f.read()

def update_instance_full(text, inst_name, w_val, l_val, nf_val, mult_val):
    pattern_w_l = r'(' + inst_name + r'\\s+.*?L=)[0-9.eE+-]+(\\s+W=)[0-9.eE+-]+'
    text = re.sub(pattern_w_l, r'\\g<1>' + str(l_val) + r'\\g<2>' + str(w_val), text, flags=re.IGNORECASE)
    
    pattern_nf = r'(' + inst_name + r'\\s+.*?nf=)[0-9.eE+-]+'
    text = re.sub(pattern_nf, r'\\g<1>' + str(nf_val), text, flags=re.IGNORECASE)
    
    pattern_mult = r'(' + inst_name + r'\\s+.*?mult=)[0-9.eE+-]+'
    text = re.sub(pattern_mult, r'\\g<1>' + str(mult_val), text, flags=re.IGNORECASE)
    return text

spice_content = update_instance_full(spice_content, 'XMplvt', W_MPLVT, L_MPLVT, NF_MPLVT, MULT_MPLVT)
spice_content = update_instance_full(spice_content, 'XMp', W_MP, L_MP, NF_MP, MULT_MP)
spice_content = update_instance_full(spice_content, 'XMnlvt', W_MNLVT, L_MNLVT, NF_MNLVT, MULT_MNLVT)
spice_content = update_instance_full(spice_content, 'XMn', W_MN, L_MN, NF_MN, MULT_MN)

spice_content = re.sub(r'\\.param vsg\\s*=\\s*[0-9.eE+-]+', f'.param vsg = {VSG_TARGET}', spice_content)
spice_content = re.sub(r'\\.param vgs\\s*=\\s*[0-9.eE+-]+', f'.param vgs = {VGS_TARGET}', spice_content)

spice_content = re.sub(
    r'dc Vgp\\s+[0-9.eE+-]+\\s+[0-9.eE+-]+\\s+[0-9.eE+-]+\\s+Vgn\\s+[0-9.eE+-]+\\s+[0-9.eE+-]+\\s+[0-9.eE+-]+',
    f'dc Vgp {VGP_START} {VGP_STOP} {VGP_STEP} Vgn {VGN_START} {VGN_STOP} {VGN_STEP}',
    spice_content
)

with open(SIM_NETLIST, 'w') as f:
    f.write(spice_content)

print(f"Netlist actualizado dinámicamente en: {SIM_NETLIST}")

# ── 3. Lanzar Simulación en NGspice ───────────────────────────────────────────
CONTAINER = "iic-osic-tools_chipathon_xvnc_uid_1000"
cmd_sim = f'export PATH=/foss/tools/xschem/bin:/foss/tools/ngspice/bin:$PATH; cd ../xschem && ngspice -b caracterizador_sim.spice'
result = subprocess.run(f'docker exec {CONTAINER} bash -c "{cmd_sim}"', shell=True, capture_output=True, text=True)

if result.returncode == 0:
    print("¡Simulación completada con éxito!")
else:
    print("Salida NGspice:", result.stdout)

# ── 4. Carga del archivo .raw usando spyci ────────────────────────────────────
raw_file_path = RAW_FILE if os.path.exists(RAW_FILE) else "/foss/designs/LDO-sky130/xschem/caracterizador.raw"
raw_data = spyci.load_raw(raw_file_path)['values']
print(f"¡Carga exitosa con spyci! Total de puntos procesados: {len(raw_data)}")""")

# 3. Celda 2: Tabla OP
code_cell2 = nbf.v4.new_code_cell("""# ==============================================================================
# Encabezado: Extracción de Tabla .OP con Geometría, Criterios de Inversión y Saturación
# Descripción: Extrae parámetros de punto de operación, calcula capacitancia y corriente 
#              totales, y evalúa los criterios de Inversión (Δov = Vgs - Vth) y 
#              Saturación (Δvd = Vds - Vdsat) para los transistores evaluados.
# ==============================================================================

import pandas as pd

p_slice = slice(0, 181)
n_slice = slice(0, None, 181)

vgs_p_sweep = np.real(abs(raw_data['v(@m.xmp.msky130_fd_pr__pfet_01v8[vgs])'][p_slice]))
vgs_n_sweep = np.real(abs(raw_data['v(@m.xmn.msky130_fd_pr__nfet_01v8[vgs])'][n_slice]))

idx_p = int(np.argmin(np.abs(vgs_p_sweep - VSG_TARGET)))
idx_n = int(np.argmin(np.abs(vgs_n_sweep - VGS_TARGET)))

transistores = {
    'Mplvt': {'tipo': 'PMOS', 'slice': p_slice, 'idx': idx_p, 'w': W_MPLVT, 'l': L_MPLVT, 'nf': NF_MPLVT, 'mult': MULT_MPLVT, 'gm': '@m.xmplvt.msky130_fd_pr__pfet_01v8_lvt[gm]', 'gds': '@m.xmplvt.msky130_fd_pr__pfet_01v8_lvt[gds]', 'id': 'i(@m.xmplvt.msky130_fd_pr__pfet_01v8_lvt[id])', 'vth': 'v(@m.xmplvt.msky130_fd_pr__pfet_01v8_lvt[vth])', 'vdsat': 'v(@m.xmplvt.msky130_fd_pr__pfet_01v8_lvt[vdsat])', 'cgg': '@m.xmplvt.msky130_fd_pr__pfet_01v8_lvt[cgg]', 'vgs': 'v(@m.xmplvt.msky130_fd_pr__pfet_01v8_lvt[vgs])'},
    'Mp':    {'tipo': 'PMOS', 'slice': p_slice, 'idx': idx_p, 'w': W_MP,    'l': L_MP,    'nf': NF_MP,    'mult': MULT_MP,    'gm': '@m.xmp.msky130_fd_pr__pfet_01v8[gm]',        'gds': '@m.xmp.msky130_fd_pr__pfet_01v8[gds]',        'id': 'i(@m.xmp.msky130_fd_pr__pfet_01v8[id])',        'vth': 'v(@m.xmp.msky130_fd_pr__pfet_01v8[vth])',        'vdsat': 'v(@m.xmp.msky130_fd_pr__pfet_01v8[vdsat])',        'cgg': '@m.xmp.msky130_fd_pr__pfet_01v8[cgg]',        'vgs': 'v(@m.xmp.msky130_fd_pr__pfet_01v8[vgs])'},
    'Mnlvt': {'tipo': 'NMOS', 'slice': n_slice, 'idx': idx_n, 'w': W_MNLVT, 'l': L_MNLVT, 'nf': NF_MNLVT, 'mult': MULT_MNLVT, 'gm': '@m.xmnlvt.msky130_fd_pr__nfet_01v8_lvt[gm]', 'gds': '@m.xmnlvt.msky130_fd_pr__nfet_01v8_lvt[gds]', 'id': 'i(@m.xmnlvt.msky130_fd_pr__nfet_01v8_lvt[id])', 'vth': 'v(@m.xmnlvt.msky130_fd_pr__nfet_01v8_lvt[vth])', 'vdsat': 'v(@m.xmnlvt.msky130_fd_pr__nfet_01v8_lvt[vdsat])', 'cgg': '@m.xmnlvt.msky130_fd_pr__nfet_01v8_lvt[cgg]', 'vgs': 'v(@m.xmnlvt.msky130_fd_pr__nfet_01v8_lvt[vgs])'},
    'Mn':    {'tipo': 'NMOS', 'slice': n_slice, 'idx': idx_n, 'w': W_MN,    'l': L_MN,    'nf': NF_MN,    'mult': MULT_MN,    'gm': '@m.xmn.msky130_fd_pr__nfet_01v8[gm]',        'gds': '@m.xmn.msky130_fd_pr__nfet_01v8[gds]',        'id': 'i(@m.xmn.msky130_fd_pr__nfet_01v8[id])',        'vth': 'v(@m.xmn.msky130_fd_pr__nfet_01v8[vth])',        'vdsat': 'v(@m.xmn.msky130_fd_pr__nfet_01v8[vdsat])',        'cgg': '@m.xmn.msky130_fd_pr__nfet_01v8[cgg]',        'vgs': 'v(@m.xmn.msky130_fd_pr__nfet_01v8[vgs])'}
}

tabla_op = []
for nombre, info in transistores.items():
    s = info['slice']
    idx = info['idx']
    m_factor = info['mult']
    
    gm_unit = float(np.real(abs(raw_data[info['gm']][s][idx])))
    gds_unit = float(np.real(abs(raw_data[info['gds']][s][idx])))
    id_unit = float(np.real(abs(raw_data[info['id']][s][idx])))
    vth = float(np.real(raw_data[info['vth']][s][idx]))
    vdsat = float(np.real(raw_data[info['vdsat']][s][idx]))
    cgg_unit = float(np.real(abs(raw_data[info['cgg']][s][idx])))
    vgs = float(np.real(abs(raw_data[info['vgs']][s][idx])))
    vds = 1.80  # Tensión VDS / VSD aplicada constante en el testbench
    
    id_total = id_unit * m_factor
    gm_total = gm_unit * m_factor
    gds_total = gds_unit * m_factor
    cgg_total = cgg_unit * m_factor  # Incluye todos los fingers (nf) y multiplicidad (mult)
    
    ro_total = 1.0 / gds_total if gds_total != 0 else np.nan
    gm_id = gm_unit / id_unit if id_unit != 0 else np.nan
    gm_ro = gm_total * ro_total
    ft = gm_unit / (2 * np.pi * cgg_unit) if cgg_unit != 0 else np.nan
    
    # ── Criterios de Inversión y Saturación ───────────────────────────────────
    delta_ov = vgs - abs(vth)   # Δov = Vgs - Vth (o VSG - |Vth|)
    delta_vd = vds - vdsat      # Δvd = Vds - Vdsat (o VSD - Vdsat)
    
    # Clasificación de la región de inversión basada en Δov
    if delta_ov < 0:
        inv_class = "Inversión Débil (Weak)"
    elif delta_ov <= 0.10:
        inv_class = "Inversión Moderada"
    else:
        inv_class = "Inversión Fuerte (Strong)"
        
    # Clasificación de la región de operación basada en Δvd
    if delta_vd > 0:
        sat_class = "Saturación"
    else:
        sat_class = "Triodo"

    tabla_op.append({
        'Transistor': nombre,
        'W (um)': info['w'],
        'L (um)': info['l'],
        'nf': info['nf'],
        'mult': info['mult'],
        'Id_total (uA)': round(id_total * 1e6, 2),
        'Cgg_total (fF)': round(cgg_total * 1e15, 2),
        'Vgs (V)': round(vgs, 2),
        'Vds (V)': round(vds, 2),
        'Vth (V)': round(vth, 3),
        'Vdsat (V)': round(vdsat, 3),
        'Δov = Vgs-Vth (V)': round(delta_ov, 3),
        'Δvd = Vds-Vdsat (V)': round(delta_vd, 3),
        'Inversión': inv_class,
        'Región': sat_class,
        'gm_total (uS)': round(gm_total * 1e6, 2),
        'ro_total (kOhm)': round(ro_total / 1e3, 2),
        'gm*ro (V/V)': round(gm_ro, 2),
        'gm/Id (1/V)': round(gm_id, 2),
        'fT (GHz)': round(ft / 1e9, 2)
    })

df_op = pd.DataFrame(tabla_op)
print(f"=== TABLA DE PUNTO DE OPERACIÓN (.OP) COMPLETA (Evaluado a VSG={vgs_p_sweep[idx_p]:.2f}V / VGS={vgs_n_sweep[idx_n]:.2f}V) ===")
display(df_op)""")

# 4. Celda 3: Gráficas Interactivas con Plotly
code_cell3 = nbf.v4.new_code_cell("""# ==============================================================================
# Encabezado: Curvas de Caracterización Analógica Interactivas (Plotly)
# Descripción: Muestra gráficos interactivos de Id_total, gm/Id, fT, ro, Vdsat 
#              vs VGS (o VSG), separados claramente para PMOS y NMOS.
# ==============================================================================

import plotly.graph_objects as go
from plotly.subplots import make_subplots

fig = make_subplots(
    rows=2, cols=5,
    subplot_titles=(
        "PMOS: Id_total vs VSG", "PMOS: gm/Id vs VSG", "PMOS: fT vs VSG", "PMOS: ro vs VSG", "PMOS: Vdsat vs VSG",
        "NMOS: Id_total vs VGS", "NMOS: gm/Id vs VGS", "NMOS: fT vs VGS", "NMOS: ro vs VGS", "NMOS: Vdsat vs VGS"
    )
)

colores = {'Mplvt': '#1f77b4', 'Mp': '#ff7f0e', 'Mnlvt': '#2ca02c', 'Mn': '#d62728'}

for nombre, info in transistores.items():
    s = info['slice']
    m_factor = info['mult']
    
    vgs = np.real(abs(raw_data[info['vgs']][s]))
    id_tot = np.real(abs(raw_data[info['id']][s])) * m_factor * 1e6  # uA
    gm = np.real(abs(raw_data[info['gm']][s]))
    gds = np.real(abs(raw_data[info['gds']][s]))
    id_u = np.real(abs(raw_data[info['id']][s]))
    vdsat = np.real(raw_data[info['vdsat']][s])
    
    gm_id = np.where(id_u > 0, gm / id_u, np.nan)
    cgg_u = np.real(abs(raw_data[info['cgg']][s]))
    ft = np.where(cgg_u > 0, gm / (2 * np.pi * cgg_u) / 1e9, np.nan) # GHz
    ro = np.where(gds > 0, (1.0 / gds) / 1e3, np.nan)               # kOhm
    
    row = 1 if info['tipo'] == 'PMOS' else 2
    c = colores[nombre]
    
    # 1. Id_total vs VGS/VSG
    fig.add_trace(go.Scatter(x=vgs, y=id_tot, mode='lines', name=nombre, line=dict(color=c, width=2), legendgroup=nombre), row=row, col=1)
    # 2. gm/Id vs VGS/VSG
    fig.add_trace(go.Scatter(x=vgs, y=gm_id, mode='lines', name=nombre, line=dict(color=c, width=2), legendgroup=nombre, showlegend=False), row=row, col=2)
    # 3. fT vs VGS/VSG
    fig.add_trace(go.Scatter(x=vgs, y=ft, mode='lines', name=nombre, line=dict(color=c, width=2), legendgroup=nombre, showlegend=False), row=row, col=3)
    # 4. ro vs VGS/VSG
    fig.add_trace(go.Scatter(x=vgs, y=ro, mode='lines', name=nombre, line=dict(color=c, width=2), legendgroup=nombre, showlegend=False), row=row, col=4)
    # 5. Vdsat vs VGS/VSG
    fig.add_trace(go.Scatter(x=vgs, y=vdsat, mode='lines', name=nombre, line=dict(color=c, width=2), legendgroup=nombre, showlegend=False), row=row, col=5)

# Actualizar ejes
for col in range(1, 6):
    fig.update_xaxes(title_text="VSG [V]", row=1, col=col)
    fig.update_xaxes(title_text="VGS [V]", row=2, col=col)

fig.update_yaxes(title_text="Id_total [uA]", row=1, col=1)
fig.update_yaxes(title_text="gm/Id [1/V]", row=1, col=2)
fig.update_yaxes(title_text="fT [GHz]", row=1, col=3)
fig.update_yaxes(title_text="ro [kOhm]", type="log", row=1, col=4)
fig.update_yaxes(title_text="Vdsat [V]", row=1, col=5)

fig.update_yaxes(title_text="Id_total [uA]", row=2, col=1)
fig.update_yaxes(title_text="gm/Id [1/V]", row=2, col=2)
fig.update_yaxes(title_text="fT [GHz]", row=2, col=3)
fig.update_yaxes(title_text="ro [kOhm]", type="log", row=2, col=4)
fig.update_yaxes(title_text="Vdsat [V]", row=2, col=5)

fig.update_layout(height=750, title_text="<b>Caracterización Analógica Completa (Id_total, gm/Id, fT, ro, Vdsat vs VGS/VSG)</b>", template="plotly_white")
fig.show()""")

nb.cells = [md_cell, code_cell1, code_cell2, code_cell3]

notebook_path = "/foss/designs/LDO-sky130/python/Untitled.ipynb"
with open(notebook_path, "w", encoding="utf-8") as f:
    nbf.write(nb, f)

print("Untitled.ipynb generado en docker:", notebook_path)
