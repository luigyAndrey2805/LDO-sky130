v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -570 -110 -570 -90 {lab=0}
N -50 260 -50 280 {lab=0}
N -50 170 -50 200 {lab=#net1}
N -510 150 -510 170 {lab=0}
N -510 -30 -510 0 {lab=#net2}
N -510 -40 -360 -40 {lab=#net2}
N -510 -40 -510 -30 {lab=#net2}
N -50 0 -50 10 {lab=vref}
N -50 0 0 0 {lab=vref}
N 90 250 90 280 {lab=0}
N 70 -120 70 -70 {lab=VDD}
N -570 -190 -570 -170 {lab=#net3}
N 590 50 590 80 {lab=#net4}
N 590 -40 590 -10 {lab=vo}
N -570 -200 -570 -190 {lab=#net3}
N -570 -200 -250 -200 {lab=#net3}
N 680 140 680 170 {lab=0}
N 590 -40 680 -40 {lab=vo}
N 680 -40 680 0 {lab=vo}
N 530 -40 590 -40 {lab=vo}
N 490 -40 490 -30 {lab=vo}
N 490 70 500 70 {lab=#net4}
N 590 140 590 160 {lab=0}
N 500 70 590 70 {lab=#net4}
N 260 -40 290 -40 {lab=#net5}
N 350 -40 400 -40 {lab=vo}
N 400 -40 400 -20 {lab=vo}
N 160 40 160 80 {lab=0}
N 400 40 400 80 {lab=0}
N 490 -40 530 -40 {lab=vo}
N 400 -40 490 -40 {lab=vo}
N 490 -30 490 10 {lab=vo}
N -510 60 -510 90 {lab=vii}
N 160 -40 160 -20 {lab=voo}
N 160 -40 200 -40 {lab=voo}
N 130 -40 160 -40 {lab=voo}
N -360 20 -360 40 {lab=0}
N -140 20 -140 40 {lab=0}
N -180 -40 -140 -40 {lab=vi}
N -270 -40 -240 -40 {lab=#net6}
N -360 -40 -330 -40 {lab=#net2}
N -140 -40 -0 -40 {lab=vi}
N -50 80 -50 110 {lab=#net7}
N -50 10 -50 20 {lab=vref}
N 0 130 0 150 {lab=0}
N -120 260 -120 280 {lab=0}
N -120 190 -120 200 {lab=#net1}
N -120 190 -50 190 {lab=#net1}
N -0 0 -0 70 {lab=vref}
N 680 60 680 80 {lab=#net8}
N -250 -140 -250 -120 {lab=0}
N -30 -140 -30 -120 {lab=0}
N -70 -200 -30 -200 {lab=VDD}
N -160 -200 -130 -200 {lab=#net9}
N -250 -200 -220 -200 {lab=#net3}
N -30 -200 70 -200 {lab=VDD}
N 70 -200 70 -120 {lab=VDD}
N 90 160 90 190 {lab=#net10}
N 90 80 90 100 {lab=#net11}
N 70 80 90 80 {lab=#net11}
N 70 30 70 80 {lab=#net11}
C {vsource.sym} -570 -140 0 0 {name=Vsuply value="dc \{VDD\} ac \{ac_vdd\}" savecurrent=false}
C {gnd.sym} -570 -90 0 0 {name=l2 lab=0}
C {vsource.sym} -50 230 0 0 {name=Vref value="\{VREF\}" savecurrent=false}
C {gnd.sym} -50 280 0 0 {name=l1 lab=0}
C {gnd.sym} 90 280 0 0 {name=l3 lab=0}
C {vsource.sym} -510 120 0 0 {name=Vin value=\{VIN\} savecurrent=false}
C {gnd.sym} -510 170 0 0 {name=l4 lab=0}
C {res.sym} 590 20 0 0 {name=R1
value=\{RL\}
footprint=1206
device=resistor
m=1}
C {gnd.sym} 590 160 0 0 {name=l5 lab=0}
C {capa-2.sym} 680 110 0 0 {name=C1
m=1
value=\{CL\}
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 680 170 0 0 {name=l6 lab=0}
C {lab_wire.sym} -60 -40 0 0 {name=p1 sig_type=std_logic lab=vi}
C {lab_wire.sym} 640 -40 0 0 {name=p2 sig_type=std_logic lab=vo}
C {lab_wire.sym} -50 0 0 0 {name=p3 sig_type=std_logic lab=vref}
C {isource.sym} 490 40 0 1 {name=Iload value="dc 0 ac 0 PULSE(\{iload_min\} \{iload_max\} \{tstart\} \{trise\} \{tfall\} \{twidth\} \{tperiod\})" savecurrent=true}
C {vsource.sym} 590 110 0 0 {name=Vsense value=0 savecurrent=false}
C {lab_wire.sym} 70 -90 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {vsource.sym} -510 30 2 0 {name=Vin1 value="dc 0 ac 0 " savecurrent=false}
C {/foss/designs/LDO-sky130/xschem/LDO_Top/LDO.sym} 150 -20 0 0 {name=x1}
C {code_shown.sym} 800 -570 0 0 {name=s1
only_topleveL=false 
value="
* ==============================================================================
* ENCABEZADO DEL ARCHIVO (ldo_tb_montecarlo.sch):
* Descripción:
*   Banco de pruebas Monte Carlo Pre-Layout (esquemático) para el regulador LDO
*   completo, incorporando los modelos parásitos de inductancia, resistencia y
*   capacitancia de línea/empaquetado en todos los pines (VIN, VOUT, VDD, Vref,
*   VSS) y la resistencia serie equivalente (ESR) del capacitor de salida.
*   Ejecuta las pruebas de Overshoot/Undershoot, PSRR, Line Regulation,
*   Load Regulation y Dropout en cada iteración estadística y exporta los
*   resultados a 'datos_mc.txt' para su análisis en 'LDO_tb_montecarlo.ipynb'.
* ==============================================================================

* 1. Librería de modelos Sky130 con variaciones estadísticas de Mismatch (tt_mm)
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt_mm

.option temp=27
.option num_threads=8
.option gmin=1e-12 reltol=1e-3 abstol=1e-12 vntol=1e-6 itl1=500 itl2=200 itl4=100

.param rsh_var = agauss(0, 0.005, 1)

* Guardar únicamente los nodos necesarios para acelerar la escritura en memoria
.save v(vo) v(voo) v(vi) v(vii) v(vdd) v(vref)

* Condiciones iniciales para garantizar convergencia DC inmediata
.nodeset V(vo)=1.2
.nodeset V(voo)=1.2
.nodeset V(x1.Vre)=0.6

* Parámetros nominales de operación del LDO
.param VDD = 1.8
.param VREF = 0.6
.param VIN = '1*VDD-0.3'
.param RL = 240e9
.param CL = 1u

* Parámetros del pulso de corriente de carga (Overshoot / Undershoot)
.param iload_min = 1u
.param iload_max = 5m
.param tstart   = 30u
.param trise    = 100n
.param tfall    = 100n
.param twidth   = 100u
.param tperiod  = 200u
.param tsim     = '2*tperiod'

.param ac_iprobe = 0
.param ac_vdd    = 0

* --- Diodos de clamp SOLO de simulación (evitan soluciones DC falsas fuera de riel) ---
Dclpn 0 vo dclamp_tb
Dclpp vo vclp dclamp_tb
Dclpn2 0 x1.vre dclamp_tb
Dclpp2 x1.vre vclp dclamp_tb
Vclp vclp 0 5
.model dclamp_tb D(IS=1e-15 N=1)

.control
* =========================================================
* CONFIGURACION DEL BUCLE MONTE CARLO PRE-LAYOUT
* =========================================================
let mc_runs = 200
let run = 1

set appendwrite
set filetype=ascii

let tperiod = 200u
let tsim = 2 * tperiod

echo === INICIO MONTE CARLO === > datos_mc.txt

* =========================================================
* INICIO DEL BUCLE MONTE CARLO
* =========================================================
while run <= mc_runs

    echo ======================================
    echo CORRIENDO MONTE CARLO ITERACION: $&run
    echo ======================================
    echo --- ITERACION: $&run --- >> datos_mc.txt

    * En la iteración 1 el circuito ya fue cargado con su primera semilla;
    * a partir de la iteración 2 hacemos UN SOLO 'reset' por chip para
    * sortear nuevos parámetros estadísticos (agauss) y restaurar las fuentes.
    if run > 1
        reset
    end

    save v(vo) v(vi) v(vdd)

    * -----------------------------------------------------
    * A. TRANSIENTE (Overshoot y Undershoot)
    * -----------------------------------------------------
    tran 5u $&tsim

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
    * Usamos 'alter' en lugar de 'alterparam + reset' para no recargar
    * la librería ni cambiar la semilla aleatoria del chip actual.
    alter @Vsuply[acmag] = 1

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

    alter @Vsuply[acmag] = 0

    * -----------------------------------------------------
    * C. TRANSIENTE (Line Regulation)
    * -----------------------------------------------------
    alter @Vin[pwl] = [ 0 1.4 1m 1.8 ]
    alter @Iload[pwl] = [ 0 1u 1m 1u ]

    tran 20u 1m

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
    alter @Vin[pwl] = [ 0 1.5 1m 1.5 ]
    alter @Iload[pwl] = [ 0 1u 1m 5m ]

    tran 20u 1m

    meas tran vout_light FIND v(vo) AT=40u
    meas tran vout_heavy FIND v(vo) AT=1m

    let load_regulation_mV = (vout_light - vout_heavy) * 1000

    echo 'load_regulation_mV = $&load_regulation_mV' >> datos_mc.txt

    * -----------------------------------------------------
    * E. TRANSIENTE (Dropout)
    * -----------------------------------------------------
    alter r1 = 240
    alter @Vin[pwl] = [ 0 2 1m 0 ]
    alter @Iload[pwl] = [ 0 1u 1m 1u ]

    tran 20u 1m

    meas tran vout_nom FIND v(vo) AT=225u
    let vout_target = vout_nom * 0.90

    meas tran vin_do FIND v(vi) WHEN v(vo) = vout_target fall=1
    let dropout_mV = (vin_do - vout_target) * 1e3

    echo 'dropout_mV = $&dropout_mV' >> datos_mc.txt

    * -----------------------------------------------------
    * Liberar los vectores de memoria RAM al terminar la iteración
    * -----------------------------------------------------
    destroy all

    let run = run + 1
end

echo === FIN MONTE CARLO === >> datos_mc.txt
echo ======================================
echo SIMULACION MONTE CARLO FINALIZADA
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
value=1.5p
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 160 80 0 0 {name=l8 lab=0}
C {gnd.sym} 400 80 0 0 {name=l9 lab=0}
C {lab_wire.sym} 180 -40 0 0 {name=p5 sig_type=std_logic lab=voo}
C {lab_wire.sym} -510 80 0 0 {name=p6 sig_type=std_logic lab=vii}
C {ind.sym} -210 -40 1 0 {name=L10
m=1
value=5n
footprint=1206
device=inductor}
C {capa-2.sym} -140 -10 0 0 {name=C4
m=1
value=2p
footprint=1206
device=polarized_capacitor}
C {capa-2.sym} -360 -10 0 0 {name=C5
m=1
value=1.5p
footprint=1206
device=polarized_capacitor}
C {res.sym} -300 -40 1 0 {name=R3
value=100m
footprint=1206
device=resistor
m=1}
C {gnd.sym} -140 40 0 0 {name=l11 lab=0}
C {gnd.sym} -360 40 0 0 {name=l12 lab=0}
C {ind.sym} -50 140 2 0 {name=L13
m=1
value=5n
footprint=1206
device=inductor}
C {res.sym} -50 50 2 0 {name=R4
value=200m
footprint=1206
device=resistor
m=1}
C {capa-2.sym} 0 100 0 0 {name=C6
m=1
value=500f
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 0 150 0 0 {name=l14 lab=0}
C {capa-2.sym} -120 230 0 0 {name=C7
m=1
value=1.5p
footprint=1206
device=polarized_capacitor}
C {gnd.sym} -120 280 0 0 {name=l15 lab=0}
C {res.sym} 680 30 2 0 {name=R5
value=20m
footprint=1206
device=resistor
m=1}
C {ind.sym} -100 -200 1 0 {name=L16
m=1
value=5n
footprint=1206
device=inductor}
C {capa-2.sym} -30 -170 0 0 {name=C8
m=1
value=10p
footprint=1206
device=polarized_capacitor}
C {capa-2.sym} -250 -170 0 0 {name=C9
m=1
value=1.5p
footprint=1206
device=polarized_capacitor}
C {res.sym} -190 -200 1 0 {name=R6
value=5m
footprint=1206
device=resistor
m=1}
C {gnd.sym} -30 -120 0 0 {name=l17 lab=0}
C {gnd.sym} -250 -120 0 0 {name=l18 lab=0}
C {ind.sym} 90 220 2 0 {name=L19
m=1
value=5n
footprint=1206
device=inductor}
C {res.sym} 90 130 2 0 {name=R7
value=5m
footprint=1206
device=resistor
m=1}
