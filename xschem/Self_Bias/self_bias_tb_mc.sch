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
N 10 -20 40 -20 {lab=Vr}
N 10 -50 10 -20 {lab=Vr}
C {gnd.sym} 90 100 0 0 {name=l1 lab=0}
C {vsource.sym} -30 -20 0 1 {name=V1 value="dc \{VDD\} ac 0 PWL(0 0 10m 0 10.1m \{VDD\} 50m \{VDD\} 50.1m 0 100m 0 101m \{VDD\} 150m \{VDD\} 150.1m 0 200m 0 300m \{VDD\} 400m \{VDD\} 400.1m 0)"}
C {lab_wire.sym} 40 -90 0 0 {name=p1 sig_type=std_logic lab=VDD
}
C {lab_wire.sym} 10 -50 0 0 {name=p2 sig_type=std_logic lab=Vr}
C {code_shown.sym} 300 -220 0 0 {name=s1
only_toplevel=false
value="
* Inclusión de libreria de modelos Sky130 PRIMERO (tt_mm habilita Mismatch/Monte Carlo)
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt_mm

.option temp=27
.option num_threads=8

* Parámetro general
.param VDD = 1.8

.control
let mc_runs = 5
let run = 1

set appendwrite
set filetype=ascii

echo === INICIO MONTE CARLO SELF BIAS === > self_bias_mc.txt

while run <= mc_runs

    echo ======================================
    echo CORRIENDO MONTE CARLO ITERACION: $&run
    echo ======================================
    echo --- ITERACION: $&run --- >> self_bias_mc.txt

    * 1. Resetear y regenerar variables aleatorias para la nueva muestra estadística
    reset
    save v(VDD) v(vr) @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id]

    * 2. Análisis Transitorio (410ms con paso de 10u)
    * Usamos 10u para no saturar el disco duro en múltiples iteraciones
    tran 10u 410m

    * Guardamos las señales en .raw (Se añadirán sucesivamente gracias a appendwrite)
    write self_bias_mc_tran.raw v(VDD) v(vr) @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id]

    * 3. Mediciones en los 3 pulsos
    
    * --- PULSO 1 (Trise = 100us, medimos en 40ms) ---
    meas tran vr_100us FIND v(vr) AT=40m
    meas tran id_100us FIND @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id] AT=40m
    
    * --- PULSO 2 (Trise = 1ms, medimos en 140ms) ---
    meas tran vr_1ms FIND v(vr) AT=140m
    meas tran id_1ms FIND @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id] AT=140m
    
    * --- PULSO 3 (Trise = 100ms, medimos en 390ms) ---
    meas tran vr_100ms FIND v(vr) AT=390m
    meas tran id_100ms FIND @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id] AT=390m

    * Convertimos las corrientes a microamperios (uA)
    let id_uA_100us = id_100us * 1000000
    let id_uA_1ms = id_1ms * 1000000
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
C {self_bias.sym} -10 -20 0 0 {name=x1}
