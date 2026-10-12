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
C {vsource.sym} -30 -20 0 1 {name=V1 value="dc \{VDD\} ac 0 pulse(0 \{VDD\} 2u 10u 10u 40u 100u)" savecurrent=false}
C {lab_wire.sym} 40 -90 0 0 {name=p1 sig_type=std_logic lab=VDD
}
C {lab_wire.sym} 10 -50 0 0 {name=p2 sig_type=std_logic lab=Vr}
C {code_shown.sym} 300 -220 0 0 {name=s1
only_toplevel=false
value="
* Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt_mm

.option temp=27
.option num_threads=8

**parametros_ldo
.param VDD    = 1.8
.param tstart = 10u
.param trise  = 200u
.param tfall  = 200u
.param tsim   = 'tstart+4*trise+3*tfall'

.control
let mc_runs = 200
let run = 1

let tstart = 10u
let trise  = 200u
let tfall  = 200u
let tsim   = tstart + 4*trise + 3*tfall

set appendwrite
set filetype=ascii

echo === INICIO MONTE CARLO SELF BIAS === > self_bias_mc.txt

while run <= mc_runs

    echo ======================================
    echo CORRIENDO MONTE CARLO ITERACION: $&run
    echo ======================================
    echo --- ITERACION: $&run --- >> self_bias_mc.txt

    * 1. Recalcular el circuito para la nueva muestra estadistica
    reset
    save v(VDD) v(Vr)  @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id]

    * 2. Transiente (Arranque con PWL)
    tran 1u 300u


    * Guardamos SOLO las señales clave en el .raw para no saturar el disco
    write self_bias_mc_tran.raw v(VDD)  v(VR) @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id]

    * 3. Medir las tensiones en Pulso 1 (AT=30u)
    meas tran vr_tran FIND v(Vr) AT=30u

    meas tran id_p1 FIND @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id] AT=30u

    * Calcular VSGP = VDD - VGP

    let vr = vr_tran
    

    * Guardar en texto
    
    * 4. Guardar resultados en el archivo de texto
    echo 'run = $&run' >> self_bias_mc.txt
    echo 'vgs = $&vr' >> self_bias_mc.txt
    echo 'id_p1 = $&id_p1' >> self_bias_mc.txt


    let run = run + 1

end

echo === FIN MONTE CARLO SELF BIAS === >> self_bias_mc.txt

.endc
"
}
C {self_bias.sym} -10 -20 0 0 {name=x1}
