v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 90 30 90 100 {lab=0}
N -30 10 -30 60 {lab=0}
N -30 60 90 60 {lab=0}
N -30 -90 -30 -50 {lab=VDD}
N -30 -90 90 -90 {lab=VDD}
N 90 -90 90 -70 {lab=VDD}
N 10 -20 40 -20 {lab=VR}
N 10 -50 10 -20 {lab=VR}
C {gnd.sym} 90 100 0 0 {name=l1 lab=0}
C {vsource.sym} -30 -20 0 1 {name=V1 value="dc \{VDD\} ac 0 PWL(0 0 0.1m 0 0.2m \{VDD\} 1.2m \{VDD\} 1.3m 0 2m 0 3m \{VDD\} 4m \{VDD\} 4.1m 0 5m 0 105m \{VDD\} 110m \{VDD\} 110.1m 0)"}
C {lab_wire.sym} 40 -90 0 0 {name=p1 sig_type=std_logic lab=VDD
}
C {lab_wire.sym} 10 -50 0 0 {name=p2 sig_type=std_logic lab=VR}
C {code_shown.sym} 300 -220 0 0 {name=s1
only_toplevel=false
value="
* ==============================================================================
* ENCABEZADO DEL ARCHIVO:
* Script de simulación Monte Carlo (Mismatch) para el circuito Self-Bias.
* Evalúa las 3 rampas de arranque (Trise = 100us, 1ms y 100ms) con tiempos de
* espera recortados (110.1ms totales en lugar de 410ms).
* ==============================================================================

* 1. Librería de modelos Sky130 con Mismatch (Monte Carlo)
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt_mm

.option temp=27
.option num_threads=8

* 2. Parámetros globales
.param VDD = 1.8
.param rsh_var = agauss(0, 0.005, 1)

.control
let mc_runs = 100
let run = 1

set appendwrite
set filetype=ascii

echo === INICIO MONTE CARLO SELF BIAS === > self_bias_mc.txt

while run <= mc_runs

    echo ======================================
    echo CORRIENDO MONTE CARLO ITERACION: $&run
    echo ======================================
    echo --- ITERACION: $&run --- >> self_bias_mc.txt

    * 1. Resetear variables aleatorias y guardar solo las señales necesarias
    reset
    save v(VDD) v(vr) @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id]

    * 2. Análisis Transitorio corto (110.1ms totales para las 3 rampas)
    tran 1m 110.1m

    write self_bias_mc_tran.raw v(VDD) v(vr) @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id]

    * 3. Mediciones en las 3 rampas
    * --- PULSO 1 (Trise = 100us: sube de 0.1m a 0.2m, medimos en 1ms) ---
    meas tran vr_100us FIND v(vr) AT=1m
    meas tran id_100us FIND @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id] AT=1m

    * --- PULSO 2 (Trise = 1ms: sube de 2m a 3m, medimos en 3.8ms) ---
    meas tran vr_1ms FIND v(vr) AT=3.8m
    meas tran id_1ms FIND @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id] AT=3.8m

    * --- PULSO 3 (Trise = 100ms: sube de 5m a 105m, medimos en 108ms) ---
    meas tran vr_100ms FIND v(vr) AT=108m
    meas tran id_100ms FIND @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id] AT=108m

    * Convertir corrientes a microamperios (uA)
    let id_uA_100us = id_100us * 1000000
    let id_uA_1ms   = id_1ms * 1000000
    let id_uA_100ms = id_100ms * 1000000

    * 4. Guardar resultados en el archivo de texto
    echo 'Resultados Iteración $&run:' >> self_bias_mc.txt
    echo '  [100us] VR = $&vr_100us V   | IBIAS = $&id_uA_100us uA' >> self_bias_mc.txt
    echo '  [1ms]   VR = $&vr_1ms V     | IBIAS = $&id_uA_1ms uA' >> self_bias_mc.txt
    echo '  [100ms] VR = $&vr_100ms V   | IBIAS = $&id_uA_100ms uA' >> self_bias_mc.txt
    echo '--------------------------------------' >> self_bias_mc.txt

    let run = run + 1

end

echo === FIN MONTE CARLO SELF BIAS === >> self_bias_mc.txt

.endc
"}
C {/foss/designs/LDO-sky130/xschem/Self_Bias/self_bias.sym} -10 -20 0 0 {name=x1}
