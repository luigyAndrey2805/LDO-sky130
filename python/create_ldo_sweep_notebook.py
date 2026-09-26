# ==============================================================================
# ARCHIVO: create_ldo_sweep_notebook.py
# DESCRIPCIÓN: Script en Python para generar el Jupyter Notebook LDO_caracterizacion.ipynb
#              usando las rutas directas del contenedor (/foss/designs/LDO-sky130/).
# ==============================================================================

import json
import os

nb_filepath = "/home/luigy/eda/designs/LDO-sky130/python/LDO_caracterizacion.ipynb"

cells = []

def add_md(text):
    cells.append({
        "cell_type": "markdown",
        "metadata": {},
        "source": [line + "\n" for line in text.split("\n")]
    })

def add_code(text):
    cells.append({
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "source": [line + "\n" for line in text.split("\n")]
    })

# Celda 1: Markdown Título y Descripción
add_md("""# Caracterización y Barrido de Parámetros del LDO Sky130
Este cuaderno simula el regulador LDO variando dimensiones ($L, W$) de resistencias y capacitores en **paralelo multihilo**.
Utiliza las rutas directas del contenedor `/foss/designs/LDO-sky130/` y la librería **`spyci`** para cargar los datos RAW.

### Componentes configurables:
- **Resistencia de Compensación OTA (`XR1_OTA`)**: $L, W$.
- **Capacitor MIM de Compensación OTA (`XC1_OTA`)**: $W, L, MF$.
- **Cargas del LDO**: $C_L$, $R_L$.
""")

# Celda 2: Importaciones y spyci
c2 = """# ==============================================================================
# ENCABEZADO: Configuración e Importación de Librerías con spyci
# DESCRIPCIÓN: Carga spyci, numpy, pandas y matplotlib para procesar los datos RAW.
# ==============================================================================

import os
import re
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import concurrent.futures
import subprocess

# Parche de compatibilidad para spyci en NumPy 2.0+
np.complex_ = np.complex128
from spyci import spyci

# Estilo visual de los gráficos
plt.style.use('seaborn-v0_8-whitegrid' if 'seaborn-v0_8-whitegrid' in plt.style.available else 'default')
plt.rcParams['font.sans-serif'] = 'Inter'
plt.rcParams['axes.edgecolor'] = '#cccccc'
plt.rcParams['axes.linewidth'] = 0.8

print("✓ Librería 'spyci' cargada correctamente.")
"""
add_code(c2)

# Celda 3: Netlist Dinámico y Motor de Simulación Paralelo con Rutas Directas del Contenedor
c3 = """# ==============================================================================
# ENCABEZADO: Netlist Dinámico y Simulación Paralela con Rutas del Contenedor
# DESCRIPCIÓN: Modifica netlist, ejecuta NGspice y lee datos desde /foss/designs/.
# ==============================================================================

BASE_SPICE_PATH = "/foss/designs/LDO-sky130/xschem/ldo_tb.spice"

def crear_netlist_simulacion(target_component, param_name, valor, out_filename):
    with open(BASE_SPICE_PATH, 'r') as f:
        content = f.read()
        
    if target_component == 'XR1_OTA':
        if param_name == 'L':
            content = re.sub(r'(XR1 VO_ota1 net1 VDD sky130_fd_pr__res_high_po W=[\d\.]+ L=)[\d\.]+', f'\\\\g<1>{valor}', content)
        elif param_name == 'W':
            content = re.sub(r'(XR1 VO_ota1 net1 VDD sky130_fd_pr__res_high_po W=)[\d\.]+', f'\\\\g<1>{valor}', content)
            
    elif target_component == 'XC1_OTA':
        if param_name == 'W':
            content = re.sub(r'(XC1 VO_ota net1 sky130_fd_pr__cap_mim_m3_2 W=)[\d\.]+', f'\\\\g<1>{valor}', content)
        elif param_name == 'L':
            content = re.sub(r'(XC1 VO_ota net1 sky130_fd_pr__cap_mim_m3_2 W=[\d\.]+ L=)[\d\.]+', f'\\\\g<1>{valor}', content)
        elif param_name == 'MF':
            content = re.sub(r'(XC1 VO_ota net1 sky130_fd_pr__cap_mim_m3_2 W=[\d\.]+ L=[\d\.]+ MF=)[\d\.]+', f'\\\\g<1>{valor}', content)
            
    elif target_component == 'CL':
        content = re.sub(r'(\.param CL =) [\d\.\w]+', f'\\\\g<1>{valor}', content)
    elif target_component == 'RL':
        content = re.sub(r'(\.param RL =) [\d\.\w]+', f'\\\\g<1>{valor}', content)
        
    with open(out_filename, 'w') as f:
        f.write(content)

def simular_instancia(args):
    idx, target_comp, param_name, val = args
    
    # Rutas directas del contenedor Docker
    tmp_dir = f"/foss/designs/LDO-sky130/python/sim_tmp/run_{idx}"
    os.makedirs(tmp_dir, exist_ok=True)
    
    spice_path = os.path.join(tmp_dir, "ldo_tb.spice")
    raw_path = os.path.join(tmp_dir, "LDO_ac.raw")
    
    crear_netlist_simulacion(target_comp, param_name, val, spice_path)
    
    cmd = f'cd "{tmp_dir}" && /foss/tools/bin/ngspice -b ldo_tb.spice'
    subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    
    freqs, mag_db, phase_deg, ugb, margen_fase, f3db = None, None, None, None, None, None
    
    # Lectura del archivo RAW directamente con spyci
    if os.path.exists(raw_path):
        try:
            raw_data = spyci.load_raw(raw_path)['values']
            freqs = np.real(raw_data['frequency'])
            vo_c = raw_data['v(vo)']
            mag_db = 20 * np.log10(np.abs(vo_c) + 1e-18)
            phase_deg = np.angle(vo_c, deg=True)
            
            # Extracción de UGB, Margen de Fase y Ancho de Banda (-3dB)
            zero_cross = np.where(np.diff(np.sign(mag_db)))[0]
            if len(zero_cross) > 0:
                i_c = zero_cross[0]
                ugb = float(freqs[i_c])
                margen_fase = float(180.0 + phase_deg[i_c])
                f3db = float(freqs[np.argmin(np.abs(mag_db - (mag_db[0] - 3.0)))])
        except Exception as e:
            pass

    return {
        'idx': idx,
        'val': val,
        'f3db': f3db,
        'ugb': ugb,
        'margen_fase': margen_fase,
        'freqs': freqs,
        'mag_db': mag_db,
        'phase_deg': phase_deg
    }

def ejecutar_barrido(target_comp, param_name, valores, max_workers=6):
    print(f"🚀 Iniciando barrido para {target_comp} ({param_name}) con {len(valores)} puntos en {max_workers} hilos...\\n")
    tasks = [(i, target_comp, param_name, val) for i, val in enumerate(valores)]
    results = []
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = [executor.submit(simular_instancia, task) for task in tasks]
        for future in concurrent.futures.as_completed(futures):
            res = future.result()
            results.append(res)
            if res['margen_fase'] is not None:
                print(f"  [✓] {target_comp}.{param_name} = {res['val']:<8} | MF: {res['margen_fase']:.2f}° | UGB: {res['ugb']:.2e} Hz")
            else:
                print(f"  [!] {target_comp}.{param_name} = {res['val']:<8} | Sin convergencia")
            
    results.sort(key=lambda x: x['idx'])
    return results
"""
add_code(c3)

# Celda 4: Configuración del Barrido Interactivo
c4 = """# ==============================================================================
# ENCABEZADO: Configuración de Parámetros a Barrer
# DESCRIPCIÓN: Selecciona el componente objetivo y los valores a simular.
# ==============================================================================

# Opciones de TARGET_COMPONENT:
# - 'XR1_OTA': Resistencia de compensación en la OTA ('L' o 'W')
# - 'XC1_OTA': Capacitor MIM de compensación en la OTA ('W', 'L' o 'MF')
# - 'CL': Capacitancia de Carga del LDO ('0.1u', '1u', '10u')
# - 'RL': Resistencia de Carga del LDO (10, 50, 100, 500)

TARGET_COMPONENT = 'XR1_OTA'  # Componente a barrer
PARAM_NAME = 'L'             # Dimensión o parámetro ('L', 'W', 'MF')

VALORES_A_BARRER = [10.0, 15.0, 22.8, 30.0, 40.0, 50.0]
NUM_HILOS_PARALELOS = 6

# Ejecutar la simulación multihilo
resultados = ejecutar_barrido(TARGET_COMPONENT, PARAM_NAME, VALORES_A_BARRER, max_workers=NUM_HILOS_PARALELOS)
"""
add_code(c4)

# Celda 5: Visualización y Gráficos
c5 = """# ==============================================================================
# ENCABEZADO: Generación de Gráficos y Tabla de Resultados
# DESCRIPCIÓN: Muestra la tabla de datos y las familias de curvas Bode.
# ==============================================================================

tabla_data = []
for r in resultados:
    tabla_data.append({
        f'{TARGET_COMPONENT}_{PARAM_NAME}': r['val'],
        'Ganancia DC (dB)': round(r['mag_db'][0], 2) if r['mag_db'] is not None else None,
        'f_-3dB (Hz)': f"{r['f3db']:.2e}" if r['f3db'] else None,
        'UGB (Hz)': f"{r['ugb']:.2e}" if r['ugb'] else None,
        'Margen de Fase (°)': round(r['margen_fase'], 2) if r['margen_fase'] else None
    })

df_res = pd.DataFrame(tabla_data)
display(df_res)

# Gráficos de Tendencias
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

x_vals = [r['val'] for r in resultados]
pm_vals = [r['margen_fase'] for r in resultados]
ugb_vals = [r['ugb'] for r in resultados]

ax1.plot(x_vals, pm_vals, 'o-', color='#1f77b4', linewidth=2, markersize=8)
ax1.set_title(f'Margen de Fase vs {TARGET_COMPONENT} ({PARAM_NAME})', fontsize=12, fontweight='bold')
ax1.set_xlabel(f'{PARAM_NAME} de {TARGET_COMPONENT}')
ax1.set_ylabel('Margen de Fase (°)')
ax1.axhline(60, color='green', linestyle='--', alpha=0.7, label='MF Óptimo = 60°')
ax1.legend()
ax1.grid(True, alpha=0.3)

ax2.plot(x_vals, ugb_vals, 's-', color='#ff7f0e', linewidth=2, markersize=8)
ax2.set_title(f'UGB (Ancho de Banda) vs {TARGET_COMPONENT} ({PARAM_NAME})', fontsize=12, fontweight='bold')
ax2.set_xlabel(f'{PARAM_NAME} de {TARGET_COMPONENT}')
ax2.set_ylabel('UGB (Hz)')
ax2.set_yscale('log')
ax2.grid(True, alpha=0.3)

plt.tight_layout()
plt.show()

# Diagrama de Bode (Magnitud y Fase)
fig, (ax_mag, ax_phase) = plt.subplots(2, 1, figsize=(12, 8), sharex=True)
colors = plt.cm.viridis(np.linspace(0, 1, len(resultados)))

for r, color in zip(resultados, colors):
    if r['freqs'] is not None and r['mag_db'] is not None:
        label_str = f"{PARAM_NAME} = {r['val']}"
        ax_mag.semilogx(r['freqs'], r['mag_db'], label=label_str, color=color, linewidth=1.8)
        ax_phase.semilogx(r['freqs'], r['phase_deg'], label=label_str, color=color, linewidth=1.8)

ax_mag.set_title(f'Respuesta en Frecuencia (Bode) - Barrido de {TARGET_COMPONENT} ({PARAM_NAME})', fontsize=13, fontweight='bold')
ax_mag.set_ylabel('Magnitud (dB)')
ax_mag.axhline(0, color='red', linestyle=':', alpha=0.6)
ax_mag.grid(True, which="both", alpha=0.3)
ax_mag.legend(loc='upper right', bbox_to_anchor=(1.15, 1.0))

ax_phase.set_xlabel('Frecuencia (Hz)')
ax_phase.set_ylabel('Fase (°)')
ax_phase.grid(True, which="both", alpha=0.3)

plt.tight_layout()
plt.show()
"""
add_code(c5)

notebook = {
    "cells": cells,
    "metadata": {
        "language_info": {
            "name": "python"
        }
    },
    "nbformat": 4,
    "nbformat_minor": 2
}

with open(nb_filepath, "w") as f:
    json.dump(notebook, f, indent=2)

print(f"Jupyter Notebook successfully created at {nb_filepath}")
