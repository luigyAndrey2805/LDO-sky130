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
N -250 -120 -250 -110 {lab=VDD}
N -250 -120 70 -120 {lab=VDD}
N -150 60 -150 70 {lab=#net1}
N 590 50 590 80 {lab=#net2}
N 590 -40 590 -10 {lab=vo}
N 680 50 680 80 {lab=0}
N 590 -40 680 -40 {lab=vo}
N 680 -40 680 -10 {lab=vo}
N 530 -40 590 -40 {lab=vo}
N 490 -40 490 -30 {lab=vo}
N 490 70 500 70 {lab=#net2}
N 590 140 590 160 {lab=0}
N 500 70 590 70 {lab=#net2}
N 160 -40 160 -20 {lab=#net3}
N 160 -40 200 -40 {lab=#net3}
N 260 -40 290 -40 {lab=#net4}
N 350 -40 400 -40 {lab=vo}
N 400 -40 400 -20 {lab=vo}
N 160 40 160 80 {lab=0}
N 400 40 400 80 {lab=0}
N 490 -40 530 -40 {lab=vo}
N 400 -40 490 -40 {lab=vo}
N 130 -40 160 -40 {lab=#net3}
N 490 -30 490 10 {lab=vo}
C {vsource.sym} -250 -60 0 0 {name=Vsuply value="dc \{VDD\} ac \{ac_vdd\}" savecurrent=false}
C {gnd.sym} -250 -10 0 0 {name=l2 lab=0}
C {vsource.sym} -50 70 0 0 {name=Vref value="\{VREF\}" savecurrent=false}
C {gnd.sym} -50 120 0 0 {name=l1 lab=0}
C {gnd.sym} 70 60 0 0 {name=l3 lab=0}
C {vsource.sym} -150 100 0 0 {name=Vin value=\{VIN\} savecurrent=false}
C {gnd.sym} -150 150 0 0 {name=l4 lab=0}
C {lab_wire.sym} -50 -40 0 0 {name=p1 sig_type=std_logic lab=vi}
C {lab_wire.sym} -50 0 0 0 {name=p3 sig_type=std_logic lab=vref}
C {lab_wire.sym} -50 -120 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {code_shown.sym} 740 -380 0 0 {name="s1" 
only_topleveL=false 
value="




.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt_mm
.option temp=27
.option num_threads=8
.param rsh_var = agauss(0, 0.005, 1)

* Forzar un punto de partida para ayudar a la convergencia
.nodeset V(VO)=1.2
.nodeset V(x1.Vre)=0.6


**parametros_ldo
.param VDD = 1.8
.param VREF = 0.6
.param VIN = '1*VDD'
.param RL = 240
.param CL = 1u
.param tsim = 2m

* Parámetros para la prueba de carga del LDO
.param iload_min = 1u
.param iload_max = 5m
.param tstart   = 30u
.param trise    = 100n
.param tfall    = 100n
.param twidth   = 100u
.param tperiod  = 200u

.param tsim = '3*tperiod'

.param ac_iprobe = 1
.param ac_vdd = 0 

.control
* =========================================================
* CONFIGURACION DEL BUCLE MONTE CARLO
* =========================================================
let mc_runs = 300
let run = 1

set appendwrite
set filetype=ascii

let tperiod = 200u
let tsim = '3*tperiod'

echo === INICIO MONTE CARLO === > datos_mc.txt

* =========================================================
* INICIO DEL BUCLE
* =========================================================
while run <= mc_runs

    echo ======================================
    echo CORRIENDO MONTE CARLO ITERACION: $&run
    echo ======================================
    echo --- ITERACION: $&run --- >> datos_mc.txt

    * -----------------------------------------------------
    * 1. PREPARAR EL CHIP PARA ESTA ITERACION
    * -----------------------------------------------------
    * Limpiamos memoria y tiramos los dados estadísticos UNA VEZ
    reset
    
    * Bloqueamos la semilla estadística para que los siguientes 'reset' 
    * evalúen exactamente las mismas variaciones físicas (el mismo chip).
    set mc_strict = 1 

    * -----------------------------------------------------
    * B. TRANSIENTE (Overshoot y Undershoot)
    * -----------------------------------------------------
    alterparam ac_iprobe = 0
    alterparam ac_vdd = 0
    alterparam RL = 240e9
    reset
    
    tran 1u $&tsim 
    
    * Acortamos los primeros 150us para evadir el pico del startup
    let t_ignorar = 150u
    
    meas tran v_estable_ligera FIND v(vo) AT=270u
    meas tran v_estable_pesada FIND v(vo) AT=180u
    meas tran vo_max MAX v(vo) from=$&t_ignorar to=$&tsim
    meas tran vo_min MIN v(vo) from=$&t_ignorar to=$&tsim
    meas tran salida_tran avg v(vo) from=$&t_ignorar to=$&tsim

    let undershoot_mV = (v_estable_ligera - vo_min) * 1e3
    let overshoot_mV = (vo_max - v_estable_pesada) * 1e3

    echo 'undershoot_mV = $&undershoot_mV' >> datos_mc.txt
    echo 'overshoot_mV = $&overshoot_mV' >> datos_mc.txt
    echo 'salida_tran = $&salida_tran' >> datos_mc.txt
    
    
    
    * -----------------------------------------------------
    * C. AC (Estabilidad)
    * -----------------------------------------------------
    alterparam ac_iprobe = 1
    alterparam ac_vdd = 0
    alterparam RL = 240
    reset 
    alter @Iload[dc] = 10m
    
    ac dec 10 1 1G
    let T_loop = v(x1.vre) / v(x1.vre2)
    let ldb = vdb(T_loop)
    let fase = vp(T_loop) * 180 / pi

    meas ac ugb WHEN ldb = 0.0
    meas ac fase_ugb FIND fase WHEN ldb = 0.0
    let margen_fase = fase_ugb
    meas ac ganancia_banda_plana find ldb at=1

    echo 'margen_fase = $&margen_fase' >> datos_mc.txt
    echo 'ganancia_banda_plana = $&ganancia_banda_plana' >> datos_mc.txt
    echo 'ugb = $&ugb' >> datos_mc.txt

    * -----------------------------------------------------
    * E. AC (PSRR)
    * -----------------------------------------------------
    alterparam ac_iprobe = 0
    alterparam ac_vdd = 1
    alterparam RL = 240
    reset 
    alter @Iload[dc] = 10m

    ac dec 10 10 1G
    let psrr1 = v(vdd)/v(vo) 
    let psrr_db = vdb(psrr1)

    meas ac gananciaPSRR_1   find psrr_db at=10
    meas ac gananciaPSRR_1k  find psrr_db at=1k
    meas ac gananciaPSRR_10k find psrr_db at=10k
    meas ac gananciaPSRR_1M  find psrr_db at=1Meg

    echo 'psrr_1 = $&gananciaPSRR_1' >> datos_mc.txt
    echo 'psrr_1k = $&gananciaPSRR_1k' >> datos_mc.txt
    echo 'psrr_10k = $&gananciaPSRR_10k' >> datos_mc.txt
    echo 'psrr_1M = $&gananciaPSRR_1M' >> datos_mc.txt

    * -----------------------------------------------------
    * D. TRANSIENTE (Line Regulation)
    * -----------------------------------------------------
    alterparam ac_iprobe = 0
    alterparam ac_vdd = 0
    alterparam RL = 240
    reset
    
    alter @Vin[pwl] = [ 0 1.4 1m 1.8 ]
    alter @Iload[pwl] = [ 0 1u 1m 1u ]
    
    tran 1u 1m 

    let t_line_ini = 40u
    let t_line_fin = 950u
    
    meas tran voline_max MAX v(vo) from=$&t_line_ini to=$&t_line_fin
    meas tran voline_min MIN v(vo) from=$&t_line_ini to=$&t_line_fin
    meas tran salida_line avg v(vo) from=$&t_line_ini to=$&t_line_fin
    let line_regulation_mV = (voline_max - voline_min)*1000

    echo 'line_regulation_mv = $&line_regulation_mV' >> datos_mc.txt
    echo 'salida_line = $&salida_line' >> datos_mc.txt

    * -----------------------------------------------------
    * F. TRANSIENTE (Load Regulation)
    * -----------------------------------------------------
    reset 
    
    alter @Iload[pwl] = [ 0 1u 1m 5m ]
    alterparam RL = 240e3
    
    tran 1u 1m 

    meas tran vout_light FIND v(vo) AT=40u
    meas tran vout_heavy FIND v(vo) AT=1m
    
    let load_regulation_mV = (vout_light - vout_heavy) * 1000

    echo 'load_regulation_mV = $&load_regulation_mV' >> datos_mc.txt

    * -----------------------------------------------------
    * G. TRANSIENTE (Dropout)
    * -----------------------------------------------------
    alterparam RL = 240
    reset
    
    alter @Vin[pwl] = [ 0 2 1m 0 ]
    alter @Iload[pwl] = [ 0 1u 1m 1u ]
    
    tran 1u 1m 

    meas tran vout_nom FIND v(vo) AT=225u
    let vout_target = vout_nom * 0.95
    
    meas tran vin_do FIND v(vi) WHEN v(vo) = vout_target fall=1
    let dropout_mV = (vin_do - vout_target) * 1e3

    echo 'dropout_mV = $&dropout_mV' >> datos_mc.txt

    * -----------------------------------------------------
    * IMPORTANTE: Desbloquear la semilla para la siguiente iteración
    * -----------------------------------------------------
    unset mc_strict 

    let run = run + 1
end

echo === FIN MONTE CARLO === >> datos_mc.txt
echo ======================================
echo SIMULACION MONTE CARLO FINALIZADA
echo ======================================
.endc







"
}
C {vsource.sym} -150 30 2 0 {name=Vin1 value="dc 0 ac 0 " savecurrent=false}
C {/foss/designs/LDO-sky130/xschem/LDO.sym} 150 -20 0 0 {name=x1}
C {res.sym} 590 20 0 0 {name=R1
value=\{RL\}
footprint=1206
device=resistor
m=1}
C {gnd.sym} 590 160 0 0 {name=l5 lab=0}
C {capa-2.sym} 680 20 0 0 {name=C1
m=1
value=\{CL\}
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 680 80 0 0 {name=l6 lab=0}
C {lab_wire.sym} 640 -40 0 0 {name=p2 sig_type=std_logic lab=vo}
C {isource.sym} 490 40 0 1 {name=Iload value="dc 0 ac 0 PULSE(\{iload_min\} \{iload_max\} \{tstart\} \{trise\} \{tfall\} \{twidth\} \{tperiod\})" savecurrent=true}
C {vsource.sym} 590 110 2 0 {name=Vsense value=0 savecurrent=false}
C {capa-2.sym} 160 10 0 0 {name=C2
m=1
value=2p
footprint=1206
device=polarized_capacitor}
C {res.sym} 230 -40 1 0 {name=R2
value=100m
footprint=1206
device=resistor
m=1}
C {ind.sym} 320 -40 1 0 {name=L7
m=1
value=5n
footprint=1206
device=inductor}
C {capa-2.sym} 400 10 0 0 {name=C3
m=1
value=1p
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 160 80 0 0 {name=l8 lab=0}
C {gnd.sym} 400 80 0 0 {name=l9 lab=0}
