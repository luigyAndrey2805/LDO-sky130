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
N -150 150 -150 170 {lab=0}
N -150 -30 -150 0 {lab=vi}
N -150 -40 -0 -40 {lab=vi}
N -150 -40 -150 -30 {lab=vi}
N -50 0 -50 10 {lab=vref}
N -50 -0 -0 0 {lab=vref}
N 70 30 70 60 {lab=0}
N 70 -120 70 -70 {lab=VDD}
N -250 -110 -250 -90 {lab=VDD}
N 590 50 590 80 {lab=#net1}
N 590 -40 590 -10 {lab=vo}
N -250 -120 -250 -110 {lab=VDD}
N -250 -120 70 -120 {lab=VDD}
N 680 50 680 80 {lab=0}
N 590 -40 680 -40 {lab=vo}
N 680 -40 680 -10 {lab=vo}
N 530 -40 590 -40 {lab=vo}
N 490 -40 490 -30 {lab=vo}
N 490 70 500 70 {lab=#net1}
N 590 140 590 160 {lab=0}
N 500 70 590 70 {lab=#net1}
N 260 -40 290 -40 {lab=#net2}
N 350 -40 400 -40 {lab=vo}
N 400 -40 400 -20 {lab=vo}
N 160 40 160 80 {lab=0}
N 400 40 400 80 {lab=0}
N 490 -40 530 -40 {lab=vo}
N 400 -40 490 -40 {lab=vo}
N 490 -30 490 10 {lab=vo}
N -150 60 -150 90 {lab=vii}
N 160 -40 160 -20 {lab=voo}
N 160 -40 200 -40 {lab=voo}
N 130 -40 160 -40 {lab=voo}
C {vsource.sym} -250 -60 0 0 {name=Vsuply value="dc \{VDD\} ac \{ac_vdd\}" savecurrent=false}
C {gnd.sym} -250 -10 0 0 {name=l2 lab=0}
C {vsource.sym} -50 70 0 0 {name=Vref value="\{VREF\}" savecurrent=false}
C {gnd.sym} -50 120 0 0 {name=l1 lab=0}
C {gnd.sym} 70 60 0 0 {name=l3 lab=0}
C {vsource.sym} -150 120 0 0 {name=Vin value=\{VIN\} savecurrent=false}
C {gnd.sym} -150 170 0 0 {name=l4 lab=0}
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
C {lab_wire.sym} -50 -40 0 0 {name=p1 sig_type=std_logic lab=vi}
C {lab_wire.sym} 640 -40 0 0 {name=p2 sig_type=std_logic lab=vo}
C {lab_wire.sym} -50 0 0 0 {name=p3 sig_type=std_logic lab=vref}
C {isource.sym} 490 40 0 1 {name=Iload value="dc 0 ac 0 PULSE(\{iload_min\} \{iload_max\} \{tstart\} \{trise\} \{tfall\} \{twidth\} \{tperiod\})" savecurrent=true}
C {vsource.sym} 590 110 0 0 {name=Vsense value=0 savecurrent=false}
C {lab_wire.sym} -50 -120 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {vsource.sym} -150 30 2 0 {name=Vin1 value="dc 0 ac 0 " savecurrent=false}
C {/foss/designs/LDO-sky130/xschem/LDO_Top/LDO.sym} 150 -20 0 0 {name=x1 lvs_ignore=true}
C {code_shown.sym} 800 -570 0 0 {name=s1
only_topleveL=false 
value="
* ==============================================================================
* ENCABEZADO DEL ARCHIVO:
* Script de simulación Monte Carlo Post-Layout (PEX) para el regulador LDO
* completo (incluyendo LDO_pex.spice).
* Evalúa Transitorio (Overshoot/Undershoot), PSRR, Line Regulation,
* Load Regulation y Dropout en cada iteración y guarda en 'datos_mc.txt'
* con el formato exacto que lee el notebook 'LDO_tb_montecarlo.ipynb'.
* ==============================================================================

* 1. Librería de modelos Sky130 con Mismatch (tt_mm) y netlist PEX del LDO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt_mm
.include /foss/designs/LDO-sky130/xschem/LDO_Top/LDO_pex.spice

.option temp=27
.option num_threads=8
.option gmin=1e-12 reltol=1e-3 abstol=1e-12 vntol=1e-6 itl1=500 itl2=200 itl4=100

.param rsh_var = agauss(0, 0.005, 1)

* Guardar únicamente los nodos clave para no desbordar la RAM con la red RC parásita
.save v(vo) v(voo) v(vi) v(vii) v(vdd) v(vref) v(x1.OTA_0.VO_ota) v(x1.OTA_0.VIP_ota) v(x1.self_bias_0.VR)

* Condiciones iniciales en los nodos reales de LDO_pex.spice para convergencia DC
.nodeset V(vo)=1.2
.nodeset V(voo)=1.2
.nodeset V(x1.OTA_0.VIP_ota)=0.6
.nodeset V(x1.OTA_0.VO_ota)=1.1
.nodeset V(x1.self_bias_0.VR)=0.6
.nodeset V(x1.self_bias_0.vgp_self)=1.0

* Parámetros del LDO
.param VDD = 1.8
.param VREF = 0.6
.param VIN = '1*VDD-0.3'
.param RL = 240e9
.param CL = 1u

* Parámetros para la prueba transitoria de carga
.param iload_min = 1u
.param iload_max = 5m
.param tstart   = 30u
.param trise    = 100n
.param tfall    = 100n
.param twidth   = 100u
.param tperiod  = 200u
.param tsim     = '3*tperiod'

.param ac_iprobe = 0
.param ac_vdd    = 0

* --- Clamp SOLO de simulación (evita soluciones DC falsas en los nodos reales del PEX) ---
Dclpn 0 vo dclamp_tb
Dclpp vo vclp dclamp_tb
Dclpn2 0 x1.OTA_0.VIP_ota dclamp_tb
Dclpp2 x1.OTA_0.VIP_ota vclp dclamp_tb
Vclp vclp 0 5
.model dclamp_tb D(IS=1e-15 N=1)

.control
* =========================================================
* CONFIGURACION DEL BUCLE MONTE CARLO PEX
* =========================================================
let mc_runs = 100
let run = 1

set appendwrite
set filetype=ascii

let tperiod = 200u
let tsim = '3*tperiod'

echo === INICIO MONTE CARLO PEX === > datos_mc.txt

* =========================================================
* INICIO DEL BUCLE
* =========================================================
while run <= mc_runs

    echo ======================================
    echo CORRIENDO MONTE CARLO PEX ITERACION: $&run
    echo ======================================
    echo --- ITERACION: $&run --- >> datos_mc.txt

    * 1. Tirar los dados estadísticos UNA VEZ para esta muestra (chip)
    reset
    set mc_strict = 1

    * -----------------------------------------------------
    * A. TRANSIENTE (Overshoot y Undershoot)
    * -----------------------------------------------------
    alterparam ac_iprobe = 0
    alterparam ac_vdd = 0
    alterparam RL = 240e9
    reset
    save v(vo) v(vi) v(vdd)

    tran 2u $&tsim

    let t_ignorar = 150u
    meas tran v_estable_ligera FIND v(vo) AT=270u
    meas tran v_estable_pesada FIND v(vo) AT=180u
    meas tran vo_max MAX v(vo) from=$&t_ignorar to=$&tsim
    meas tran vo_min MIN v(vo) from=$&t_ignorar to=$&tsim
    meas tran salida_tran avg v(vo) from=$&t_ignorar to=$&tsim

    let undershoot_mV = (v_estable_ligera - vo_min) * 1e3
    let overshoot_mV  = (vo_max - v_estable_pesada) * 1e3

    echo 'undershoot_mV = $&undershoot_mV' >> datos_mc.txt
    echo 'overshoot_mV = $&overshoot_mV' >> datos_mc.txt
    echo 'salida_tran = $&salida_tran' >> datos_mc.txt

    * -----------------------------------------------------
    * B. AC (PSRR)
    * -----------------------------------------------------
    alterparam ac_iprobe = 0
    alterparam ac_vdd = 1
    alterparam RL = 240e9
    reset
    save v(vdd) v(vo)
    alter @Iload[dc] = 5m

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
    * C. TRANSIENTE (Line Regulation)
    * -----------------------------------------------------
    alterparam ac_iprobe = 0
    alterparam ac_vdd = 0
    alterparam RL = 240e9
    reset
    save v(vo) v(vi)

    alter @Vin[pwl] = [ 0 1.4 1m 1.8 ]
    alter @Iload[pwl] = [ 0 1u 1m 1u ]

    tran 2u 1m

    let t_line_ini = 40u
    let t_line_fin = 950u

    meas tran voline_max MAX v(vo) from=$&t_line_ini to=$&t_line_fin
    meas tran voline_min MIN v(vo) from=$&t_line_ini to=$&t_line_fin
    meas tran salida_line avg v(vo) from=$&t_line_ini to=$&t_line_fin
    let line_regulation_mV = (voline_max - voline_min) * 1000

    echo 'line_regulation_mv = $&line_regulation_mV' >> datos_mc.txt
    echo 'salida_line = $&salida_line' >> datos_mc.txt

    * -----------------------------------------------------
    * D. TRANSIENTE (Load Regulation)
    * -----------------------------------------------------
    alterparam RL = 240e9
    reset
    save v(vo)

    alter @Iload[pwl] = [ 0 1u 1m 5m ]

    tran 2u 1m

    meas tran vout_light FIND v(vo) AT=40u
    meas tran vout_heavy FIND v(vo) AT=1m

    let load_regulation_mV = (vout_light - vout_heavy) * 1000

    echo 'load_regulation_mV = $&load_regulation_mV' >> datos_mc.txt

    * -----------------------------------------------------
    * E. TRANSIENTE (Dropout)
    * -----------------------------------------------------
    alterparam RL = 240
    reset
    save v(vo) v(vi)

    alter @Vin[pwl] = [ 0 2 1m 0 ]
    alter @Iload[pwl] = [ 0 1u 1m 1u ]



    meas tran vout_nom FIND v(vo) AT=225u
    let vout_target = vout_nom * 0.90

    meas tran vin_do FIND v(vi) WHEN v(vo) = vout_target fall=1
    let dropout_mV = (vin_do - vout_target) * 1e3

    echo 'dropout_mV = $&dropout_mV' >> datos_mc.txt

    * -----------------------------------------------------
    * Desbloquear la semilla y liberar memoria RAM para la siguiente iteración
    * -----------------------------------------------------
    unset mc_strict
    plot tran2.vo
    destroy tran1 ac1 tran2 tran3 tran4

    let run = run + 1
    
end

echo === FIN MONTE CARLO PEX === >> datos_mc.txt
echo ======================================
echo SIMULACION MONTE CARLO PEX FINALIZADA
echo ======================================
.endc
"
}
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
C {lab_wire.sym} 180 -40 0 0 {name=p5 sig_type=std_logic lab=voo}
C {lab_wire.sym} -150 80 0 0 {name=p6 sig_type=std_logic lab=vii}
