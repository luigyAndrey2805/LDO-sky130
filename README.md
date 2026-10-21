<!--
================================================================================
Archivo: README.md
Descripción:
    Documento principal del repositorio LDO-sky130. Describe la arquitectura,
    especificaciones eléctricas, distribución de pines (Pinout) y notas de
    integración en el anillo de pads (incluyendo el uso de dos ramas en Metal 3
    para VOUT y VIN), resultados de verificación física (DRC, LVS y PEX) y la
    organización de todos los entregables para la convocatoria Silicluster v3
    (OnChip-UIS) en tecnología SkyWater 130 nm (sky130A).
================================================================================
-->

# Regulador LDO Integrado en SkyWater 130 nm (`sky130A`) — Silicluster v3 (OnChip-UIS)

Diseño, caracterización exhaustiva (Esquemático, 27 esquinas PVT, Monte Carlo de 200 iteraciones y Post-Layout PEX) e implementación física (*Full-Custom Layout*) de un regulador lineal de baja caída (**LDO**) utilizando herramientas EDA de código abierto (**Xschem**, **Ngspice**, **KLayout**, **Magic** y **Netgen**) en el nodo tecnológico **SkyWater 130 nm (`sky130A`)**.

---

## 1. Arquitectura del Sistema

El regulador LDO está conformado por tres bloques fundamentales integrados en un único macro analógico:

1. **Referencia de Corriente Autopolarizada (`self_bias`):**
   - Fuente de corriente *Beta-Multiplier* insensible a variaciones de $V_{DD}$ con circuito de arranque (*Start-up*) activo y espejo cascodo PMOS LVT + NMOS estándar.
   - Genera el voltaje de polarización $V_{\text{gn\_bias}}$ ($\approx 605\text{ mV}$, $I_{\text{ref}} \approx 5\ \mu\text{A}$) para el amplificador de error.
2. **Amplificador de Error de Dos Etapas (`OTA`):**
   - Par diferencial de entrada PMOS LVT (`sky130_fd_pr__pfet_01v8_lvt`, $W=26\ \mu\text{m}, L=1\ \mu\text{m}, nf=4$) con carga activa NMOS y segunda etapa de ganancia en fuente común.
   - Red interna de compensación Miller con resistencia de anulación de cero ($R_z = 90.72\ \mu\text{m}$ en `res_xhigh_po_0p35` y capacitor MIM $C_{\text{Miller}} \approx 5.0\text{ pF}$).
3. **Etapa de Potencia y Red de Realimentación (`LDO` Top):**
   - **Transistor de Paso (`M1`):** PMOS LVT de gran ancho ($W = 750\ \mu\text{m}, L = 0.5\ \mu\text{m}, nf = 75$) para soportar corrientes de carga de hasta $I_{\text{load}} = 20\text{ mA}$ con bajo voltaje de *dropout*.
   - **Divisor Resistivo ($R_1, R_{11}$) y Resistor *Bleeder* ($R_2$):** Implementados con polisilicio de alta resistividad (`res_xhigh_po_0p69`, $R_1 = R_{11}$ para $V_{\text{OUT}} = 2 \cdot V_{\text{ref}}$) y resistencia de descarga mínima $R_2$ para garantizar estabilidad sin carga externa.
   - **Capacitor *Feedforward* ($C_{\text{ff}} \approx 2.1\text{ pF}$):** Capacitor MIM en paralelo con la rama superior de realimentación ($R_1$) para mejorar el margen de fase y la respuesta transitoria ante escalones de carga.

---

## 2. Tabla de Pines (Pinout) y Notas de Integración Top-Level

El diseño cumple estrictamente la plantilla de integración de **Silicluster v3**:
- **Área total del bloque:** **$152.43\ \mu\text{m} \times 82.91\ \mu\text{m}$** (dentro del límite máximo de $180\ \mu\text{m} \times 115\ \mu\text{m}$, con orientación horizontal).
- **Power Grid (`VDD`, `VSS`):** Rieles verticales en **Metal 4 (`met4`)** y rieles horizontales superiores en **Metal 5 (`met5`)**.
- **Puertos de Señal y Potencia (`VIN`, `VOUT`, `Vref`):** Dispuestos en **Metal 3 (`met3`, capa `70/20` con etiquetas en `70/5`)**, dejando libres las capas superiores `met4` y `met5` para la grilla de alimentación del chip.

| Nombre del Pin | Dirección (`LDO.v`) | Capa en Layout | Ancho de Pista | Coordenadas de Acceso en el Macro ($\mu\text{m}$) | Asignación Solicitada en el Chip |
| :--- | :---: | :---: | :---: | :--- | :--- |
| **`VDD`** | `inout` | `met4` (V) / `met5` (H) | $1.0\ \mu\text{m}$ / $2.0\ \mu\text{m}$ | Riel superior: $Y \in [50.77, 52.77]$ | Riel común `VDD` ($1.8\text{ V}$) |
| **`VSS`** | `inout` | `met4` (V) / `met5` (H) | $1.0\ \mu\text{m}$ / $2.0\ \mu\text{m}$ | Riel superior: $Y \in [46.77, 48.77]$ | Riel común `VSS` ($0\text{ V}$) |
| **`VIN`** | `input` | **`met3`** (`70/20`) | $2.0\ \mu\text{m}$ (x2 ramas) | **Rama Izq:** $X = -63.76,\ Y \in [37.00, 39.00]$<br>**Rama Der:** $X = +88.67,\ Y \in [37.00, 39.00]$ | Pad(s) analógicos directos de entrada ($1.4\text{–}1.8\text{ V}$, hasta $20\text{ mA}$) |
| **`Vref`** | `input` | **`met3`** (`70/20`) | $0.30\ \mu\text{m}$ | **Acceso Izq:** $X = -42.44,\ Y \in [10.72, 11.02]$ | 1 Pad analógico de entrada ($0.6\text{ V}$ nominal, alta impedancia) |
| **`VOUT`** | `output` | **`met3`** (`70/20`) | $2.0\ \mu\text{m}$ (x2 ramas) | **Rama Izq:** $X = -63.74,\ Y \in [32.51, 34.51]$<br>**Rama Der:** $X = +88.66,\ Y \in [32.515, 34.515]$ | **2 Pines / Pads analógicos de salida** conectados a las dos ramas de `met3` |

> [!IMPORTANT]
> **Nota de Integración para `VOUT` y `VIN` (Solicitud de 2 Pines/Pads de Salida en `VOUT`):**
> Dado que el regulador LDO entrega una corriente máxima de hasta **$I_{\text{load}} = 20\text{ mA}$**, el nodo **`VOUT`** fue diseñado con **dos ramas laterales de salida en `met3` de $2.0\ \mu\text{m}$ de ancho** hacia ambos extremos del macro (izquierdo en $X = -63.74\ \mu\text{m}$ y derecho en $X = +88.66\ \mu\text{m}$, unidas internamente mediante 3 rieles paralelos de `met3` sobre el transistor de paso `M1`).
> - Se solicita conectar **ambas ramas de `VOUT` en `met3` a dos (2) pines/pads analógicos de salida independientes** (sin resistencia ESD en serie), permitiendo dividir la corriente máxima ($10\text{ mA}$ por rama) para minimizar la caída $I \cdot R$ y habilitar mediciones Kelvin (*Force / Sense*) en silicio (usando la rama derecha, contigua al divisor $R_1/R_{11}$, como sensado Kelvin).
> - De igual forma, **`VIN`** cuenta con dos ramas simétricas de $2.0\ \mu\text{m}$ en `met3` a izquierda y derecha para alimentar los $20\text{ mA}$ hacia el *Source* de `M1` con mínima resistencia serie.

---

## 3. Resumen de Desempeño y Validación (PVT, Monte Carlo y PEX)

El regulador fue validado bajo condiciones nominales ($V_{DD} = 1.8\text{ V}$, $V_{\text{IN}} = 1.5\text{ V}$, $V_{\text{ref}} = 0.6\text{ V}$, $T = 27\ ^\circ\text{C}$, esquina `tt`), a través de **27 esquinas PVT** ($\text{Proceso} \in \{\text{tt, ff, ss, sf, fs}\}$, $V_{DD} \in \{1.62, 1.80, 1.98\}\text{ V}$, $T \in \{-40, 27, 125\}\ ^\circ\text{C}$), **Monte Carlo (200 muestras)** y extracción **Post-Layout con parásitos RC (`PEX`)**:

| Parámetro | Condición de Prueba | Nominal (`tt`,Esquemático) | Rango en 27 Corners PVT (PEX) | Monte Carlo ($\mu \pm \sigma$, 200 iter.) |
| :--- | :--- | :---: | :---: | :---: |
| **Voltaje de Salida ($V_{\text{OUT}}$)** | $V_{\text{ref}} = 0.6\text{ V},\ I_{\text{load}} = 1\text{ mA}$ | **$1.201\text{ V}$** | $1.196\text{ V} \text{ – } 1.206\text{ V}$ | $1.201\text{ V} \pm 4.8\text{ mV}$ |
| **Ganancia de Lazo DC ($A_{v0}$)** | Lazo abierto AC ($1\text{ Hz}$) | **$69.8\text{ dB}$** | $55.0\text{ dB} \text{ – } 72.1\text{ dB}$ | $69.4\text{ dB} \pm 1.9\text{ dB}$ |
| **Margen de Fase ($\text{PM}$)** | $C_L = 1\ \mu\text{F}$ | **$82.1^\circ$** | $50.7^\circ \text{ – } 87.3^\circ$ | $81.8^\circ \pm 2.1^\circ$ |
| **PSRR a $1\text{ kHz}$** | Perturbación AC en $V_{DD}$ | **$-55.6\text{ dB}$** | $-42.6\text{ dB} \text{ – } -57.9\text{ dB}$ | $-55.2\text{ dB} \pm 1.6\text{ dB}$ |
| **Regulación de Línea (*Line Reg.*)** | $V_{\text{IN}}: 1.4\text{ V} \rightarrow 1.8\text{ V}$ | **$1.27\text{ mV}$** | $0.51\text{ mV} \text{ – } 6.72\text{ mV}$ | $1.35\text{ mV} \pm 0.42\text{ mV}$ |
| **Regulación de Carga (*Load Reg.*)** | $I_{\text{load}}: 1\ \mu\text{A} \rightarrow 5\text{ mA}$ | **$0.29\text{ mV}$** | $0.27\text{ mV} \text{ – } 3.55\text{ mV}$ | $0.32\text{ mV} \pm 0.11\text{ mV}$ |
| **Voltaje de *Dropout* ($V_{\text{DO}}$)** | Caída del $10\%$ en $V_{\text{OUT}}$ | **$85.3\text{ mV}$** | $83.1\text{ mV} \text{ – } 108.4\text{ mV}$ | $86.1\text{ mV} \pm 4.5\text{ mV}$ |
| ***Undershoot* / *Overshoot*** | Escalón $I_{\text{load}}: 1\ \mu\text{A} \leftrightarrow 5\text{ mA}$ ($100\text{ ns}$) | **$8.6\text{ mV} / 6.2\text{ mV}$** | $6.3\text{ mV} \text{ – } 35.8\text{ mV}$ | $8.9\text{ mV} \pm 1.4\text{ mV}$ |

---

## 4. Verificación Física (DRC, LVS y PEX)

- **DRC (KLayout `sky130A_mr.drc` — `feol=true`, `beol=true`, `offgrid=true`):** **0 violaciones**.
- **DRC (Magic `sky130A.magicrc`):** **0 violaciones** (`Total DRC errors found: 0` en los archivos de entrega dentro de `Archivos GDS y MAG/` y `gds/gds_flatten/`).
- **LVS (KLayout / Netgen contra `LDO.sch`):** **`Congratulations! Netlists match.`** (`Circuits match uniquely`).

---

## 5. Estructura del Repositorio y Entregables

```text
LDO-sky130/
├── Archivos GDS y MAG/                       # Archivos finales de layout limpios (0 DRC en Magic y KLayout)
│   ├── LDO.gds                               # Layout GDSII final del macro LDO (152.43 um x 82.91 um)
│   └── LDO.mag                               # Layout nativo de Magic autocontenido (0 errores DRC)
├── gds/                                      # Layouts jerárquicos por sub-bloque y versión aplanada
│   ├── LDO.gds                               # Layout GDSII jerárquico del LDO completo
│   ├── OTA.gds                               # Layout GDSII del amplificador de error (OTA)
│   ├── sel_bias.gds                          # Layout GDSII de la referencia de corriente (Self-Bias)
│   └── gds_flatten/                          # Respaldo de LDO.gds y LDO.mag aplanados sin errores DRC
├── xschem/                                   # Esquemáticos, símbolos y bancos de prueba (Testbenches)
│   ├── LDO_Top/
│   │   ├── LDO.sch / LDO.sym                 # Esquemático y símbolo principal del regulador LDO
│   │   ├── LDO_pex.spice                     # Netlist extraído con parásitos RC (PEX) del LDO
│   │   ├── ldo_tb.sch                        # Testbench principal (OP, AC Estabilidad, PSRR, Line/Load Reg, Dropout, Tran)
│   │   ├── ldo_tb_pex.sch                    # Testbench configurado para simulación Post-Layout (PEX)
│   │   └── ldo_tb_montecarlo.sch             # Testbench para análisis estadístico de Monte Carlo
│   ├── OTA/
│   │   ├── OTA.sch / OTA.sym                 # Esquemático y símbolo del OTA de dos etapas
│   │   ├── OTA_pex.spice                     # Netlist extraído con parásitos RC del OTA
│   │   └── OTA_tb.sch / OTA_tbtran.sch       # Testbenches de caracterización AC/DC y transitoria del OTA
│   └── Self_Bias/
│       ├── self_bias.sch / self_bias.sym     # Esquemático y símbolo de la referencia autopolarizada
│       ├── self_bias_pex.spice               # Netlist extraído con parásitos RC del Self-Bias
│       ├── self_bias_tb.sch                  # Testbench DC/Arranque de la referencia de corriente
│       ├── self_bias_tb_pex.sch              # Testbench Post-Layout (PEX) del Self-Bias
│       └── self_bias_tb_mc.sch               # Testbench de Monte Carlo del Self-Bias
├── python/                                   # Notebooks de automatización, post-procesamiento y gráficas
│   ├── LDO_PVT.ipynb                         # Simulación y gráficas en 27 esquinas PVT (Esquemático)
│   ├── LDO_PVT_PEX.ipynb                     # Simulación de las 27 esquinas PVT en Post-Layout (PEX)
│   ├── Codigos_prueba.ipynb                  # Filtrado y generación de reportes/gráficas comparativas PEX
│   ├── LDO_tb_montecarlo.ipynb               # Procesamiento e histogramas de Monte Carlo del LDO
│   ├── Resultados en PVT /                   # Tablas CSV y gráficas generadas en PVT (Esquemático)
│   ├── Resultados en PVT _ PEX/              # Tablas CSV y gráficas generadas en PVT (Post-Layout PEX)
│   └── Resultados_Montecarlo/                # Histogramas y métricas estadísticas de Monte Carlo
├── LDO.v                                     # Definición Verilog Black-Box del módulo LDO y sus puertos
├── Validacion_LDO_Sky130_OnChip.pptx.pdf     # Documento de validación de diseño (formato OnChip-UIS)
└── klayout_sky130_colors.lyp                 # Archivo de propiedades visuales de capas Sky130 para KLayout
```
