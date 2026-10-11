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
N 140 -20 190 -20 {lab=Vgp}
C {gnd.sym} 90 100 0 0 {name=l1 lab=0}
C {vsource.sym} -30 -20 0 1 {name=V1 value="dc \{VDD\} ac 0 PWL(0 0 \{tstart\} 0 \{tstart+trise\} 1.8)" savecurrent=fals}
C {lab_wire.sym} 40 -90 0 0 {name=p1 sig_type=std_logic lab=VDD
}
C {lab_wire.sym} 190 -20 0 0 {name=p2 sig_type=std_logic lab=Vgp}
C {code_shown.sym} 300 -210 0 0 {name=s1
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
let mc_runs = 100
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

    * 2. Transiente (Arranque con PWL)
    tran 1u $&tsim

    * Guardamos SOLO las señales clave en el .raw para no saturar el disco
    write self_bias_mc_tran.raw v(VDD) v(Vgp) v(x1.VDI) v(x1.VR)

    * 3. Medir las tensiones en Pulso 1 (300u) y Pulso 2 (1100u)
    meas tran vgp_p1 FIND v(Vgp)    AT=300u
    meas tran vdi_p1 FIND v(x1.VDI) AT=300u
    meas tran vr_p1  FIND v(x1.VR)  AT=300u

    meas tran vgp_p2 FIND v(Vgp)    AT=1100u
    meas tran vdi_p2 FIND v(x1.VDI) AT=1100u
    meas tran vr_p2  FIND v(x1.VR)  AT=1100u

    let vsgp_p1 = 1.8 - vgp_p1
    let vsgp_p2 = 1.8 - vgp_p2

    * 4. Guardar resultados en el archivo de texto
    echo 'run = $&run' >> self_bias_mc.txt
    echo 'vgp_p1 = $&vgp_p1' >> self_bias_mc.txt
    echo 'vdi_p1 = $&vdi_p1' >> self_bias_mc.txt
    echo 'vr_p1 = $&vr_p1' >> self_bias_mc.txt
    echo 'vsgp_p1 = $&vsgp_p1' >> self_bias_mc.txt
    echo 'vgp_p2 = $&vgp_p2' >> self_bias_mc.txt
    echo 'vdi_p2 = $&vdi_p2' >> self_bias_mc.txt
    echo 'vr_p2 = $&vr_p2' >> self_bias_mc.txt
    echo 'vsgp_p2 = $&vsgp_p2' >> self_bias_mc.txt

    * 5. CLAVE: Borrar los vectores de la RAM de esta iteracion
    * (Los contadores como 'run' y 'mc_runs' viven en 'const', así que no se borran)
    destroy all

    let run = run + 1

end

echo === FIN MONTE CARLO SELF BIAS === >> self_bias_mc.txt

.endc
"
}
C {self_bias.sym} -10 -20 0 0 {name=x1}
