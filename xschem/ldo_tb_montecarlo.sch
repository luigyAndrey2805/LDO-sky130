v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -250 -30 -250 -10 {lab=0}
N -50 100 -50 120 {lab=0}
N -50 10 -50 40 {lab=vref}
N -150 130 -150 150 {lab=0}
N -150 -30 -150 0 {lab=vi}
N -150 -40 -0 -40 {lab=vi}
N -150 -40 -150 -30 {lab=vi}
N -50 0 -50 10 {lab=vref}
N -50 -0 -0 0 {lab=vref}
N 70 30 70 60 {lab=0}
N 70 -120 70 -70 {lab=VDD}
N -250 -110 -250 -90 {lab=VDD}
N 260 50 260 80 {lab=0}
N 260 -40 260 -10 {lab=vo}
N 130 -40 200 -40 {lab=vo}
N -250 -120 -250 -110 {lab=VDD}
N -250 -120 70 -120 {lab=VDD}
N 350 50 350 80 {lab=0}
N 260 -40 350 -40 {lab=vo}
N 350 -40 350 -10 {lab=vo}
N 200 -40 260 -40 {lab=vo}
N 160 -40 160 -30 {lab=vo}
N 160 30 160 70 {lab=#net1}
N 160 70 170 70 {lab=#net1}
N 230 70 260 70 {lab=0}
N -150 60 -150 70 {lab=#net2}
C {vsource.sym} -250 -60 0 0 {name=Vsuply value="dc \{VDD\} ac \{ac_vdd\}" savecurrent=false}
C {gnd.sym} -250 -10 0 0 {name=l2 lab=0}
C {vsource.sym} -50 70 0 0 {name=Vref value="\{VREF\}" savecurrent=false}
C {gnd.sym} -50 120 0 0 {name=l1 lab=0}
C {gnd.sym} 70 60 0 0 {name=l3 lab=0}
C {vsource.sym} -150 100 0 0 {name=Vin value=\{VIN\} savecurrent=false}
C {gnd.sym} -150 150 0 0 {name=l4 lab=0}
C {res.sym} 260 20 0 0 {name=R1
value=\{RL\}
footprint=1206
device=resistor
m=1}
C {gnd.sym} 260 80 0 0 {name=l5 lab=0}
C {capa-2.sym} 350 20 0 0 {name=C1
m=1
value=\{CL\}
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 350 80 0 0 {name=l6 lab=0}
C {lab_wire.sym} -50 -40 0 0 {name=p1 sig_type=std_logic lab=vi}
C {lab_wire.sym} 310 -40 0 0 {name=p2 sig_type=std_logic lab=vo}
C {lab_wire.sym} -50 0 0 0 {name=p3 sig_type=std_logic lab=vref}
C {isource.sym} 160 0 0 0 {name=Iload value="dc 0 ac 0 PULSE(\{iload_min\} \{iload_max\} \{tstart\} \{trise\} \{tfall\} \{twidth\} \{tperiod\})" savecurrent=true}
C {vsource.sym} 200 70 1 0 {name=Vsense value=0 savecurrent=false}
C {lab_wire.sym} -50 -120 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {code_shown.sym} 620 -380 0 0 {name="s1" 
only_topleveL=false 
value="


.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt_mm

.option temp=125
.option num_threads=8

**parametros_ldo
.param VDD = 1.8
.param VREF = 0.6
.param VIN = '1*VDD'
.param RL = 24
.param CL = 1u

* Parámetros para la prueba de carga del LDO
.param iload_min = 1m
.param iload_max = 50m
.param tstart   = 10u
.param trise    = 100n
.param tfall    = 100n
.param twidth   = 200u
.param tperiod  = 400u
.param tsim = '5*tperiod'

.param ac_iprobe = 1
.param ac_vdd = 0

.control
* =========================================================
* 1. CONFIGURACIÓN DEL BUCLE MONTE CARLO
* =========================================================
let mc_runs = 100
let run = 1

set appendwrite
set filetype=ascii

* En .control 'let' NO acepta comillas: se evalua directamente la expresion
let tperiod  = 400u
let tsim = 5*tperiod

* ---> CREAR EL ARCHIVO LIMPIO ANTES DEL BUCLE <---
* El símbolo '>' crea un archivo nuevo o borra el anterior si existía
echo === INICIO MONTE CARLO === > datos_mc.txt

* =========================================================
* 2. INICIO DEL BUCLE
* =========================================================
while run <= mc_runs
    alterparam ac_iprobe = 1
    alterparam ac_vdd = 0
    alterparam RL = 24

    * Mensajes en la consola de Ngspice para que veas el progreso visual
    echo ======================================
    echo CORRIENDO MONTE CARLO ITERACION: $&run
    echo ======================================

    * Guardamos un separador de iteración en el archivo de texto
    echo --- ITERACION: $&run --- >> datos_mc.txt

    * Tira los dados estadísticos para crear un nuevo chip
    reset

    * -----------------------------------------------------
    * B. TRANSIENTE (Overshoot y Undershoot)
    * -----------------------------------------------------
    tran 1u $&tsim
    write LDO_mc_tran.raw

    meas tran v_estable_ligera FIND v(vo) AT=9u
    meas tran v_estable_pesada FIND v(vo) AT=209u
    meas tran vo_max MAX v(vo)
    meas tran vo_min MIN v(vo)

    let undershoot_mV = (v_estable_ligera - vo_min) * 1e3
    let overshoot_mV = (vo_max - v_estable_pesada) * 1e3

    * Escribimos los datos en el archivo .txt usando '>>'
    echo 'undershoot_mV = $&undershoot_mV' >> datos_mc.txt
    echo 'overshoot_mV = $&overshoot_mV' >> datos_mc.txt

    * -----------------------------------------------------
    * C. AC (Estabilidad y Ganancia de Lazo Abierto)
    * -----------------------------------------------------
    ac dec 10 1 1G
    * 1. Ganancia de Lazo Abierto T(s) = v(x1.vre) / v(x1.vre2)
    let T_loop = v(x1.vre) / v(x1.vre2)
    let ldb = vdb(T_loop)
    let fase = vp(T_loop) * 180 / pi

    write LDO_mc_ac_estability.raw

    meas ac ugb WHEN ldb = 0.0
    meas ac fase_ugb FIND fase WHEN ldb = 0.0
    let margen_fase = fase_ugb
    meas ac ganancia_banda_plana find ldb at=1

    echo 'margen_fase = $&margen_fase' >> datos_mc.txt
    echo 'ganancia_banda_plana = $&ganancia_banda_plana' >> datos_mc.txt
    echo 'ugb = $&ugb' >> datos_mc.txt

    * -----------------------------------------------------
    * D. DC (Line Regulation)
    * -----------------------------------------------------
    dc vin 1.3 2 0.01
    write LDO_mc_dc_line.raw

    meas dc voline_max MAX v(vo)
    meas dc voline_min MIN v(vo)
    let line_regulation = (voline_max - voline_min)*1000

    echo 'line_regulation = $&line_regulation' >> datos_mc.txt

    * -----------------------------------------------------
    * E. AC (PSRR)
    * -----------------------------------------------------
    alterparam ac_iprobe = 0
    alterparam ac_vdd = 1
    reset
    ac dec 10 1 1G
    let psrr1 = v(vdd)/v(vo)
    let psrr_db = vdb(psrr1)
    write LDO_mc_ac_psrr.raw

    meas ac gananciaPSRR_1   find psrr_db at=1
    meas ac gananciaPSRR_1k  find psrr_db at=1k
    meas ac gananciaPSRR_10k find psrr_db at=10k
    meas ac gananciaPSRR_1M  find psrr_db at=1Meg

    echo 'psrr_1 = $&gananciaPSRR_1' >> datos_mc.txt
    echo 'psrr_1k = $&gananciaPSRR_1k' >> datos_mc.txt
    echo 'psrr_10k = $&gananciaPSRR_10k' >> datos_mc.txt
    echo 'psrr_1M = $&gananciaPSRR_1M' >> datos_mc.txt

    * -----------------------------------------------------
    * F. DC (Load Regulation)
    * -----------------------------------------------------
    alterparam RL = 1e9
    reset
    dc iload 400u 50m 100u
    write LDO_mc_dc_load.raw

    meas dc voload_max MAX v(vo)
    meas dc voload_min MIN v(vo)
    let load_regulation = (voload_max - voload_min)*1000

    echo 'load_regulation = $&load_regulation' >> datos_mc.txt

    * -----------------------------------------------------
    * G. DC (Dropout)
    * -----------------------------------------------------
    alterparam RL = 24
    reset
    dc vin1 0 2 0.01
    write LDO_mc_dc_dropout.raw

    meas dc vout_nom FIND v(vo) WHEN vi = 1.55
    let vout_target = vout_nom * 0.995
    meas dc vin_do FIND vi WHEN vo = vout_target fall=1
    let dropout_mV = (vin_do - vout_target) * 1e3

    echo 'dropout_mV = $&dropout_mV' >> datos_mc.txt

    * Avanzamos el contador del bucle
    let run = run + 1
end

* Al terminar, imprimimos que finalizó
echo ======================================
echo SIMULACION MONTE CARLO FINALIZADA
echo ======================================
echo === FIN MONTE CARLO === >> datos_mc.txt

.endc

"
}
C {vsource.sym} -150 30 2 0 {name=Vin1 value="dc 0 ac 0 " savecurrent=false}
C {/foss/designs/LDO-sky130/xschem/LDO.sym} 150 -20 0 0 {name=x1}
