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
N -150 60 -150 80 {lab=0}
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
C {/foss/designs/LDO-sky130/xschem/LDO.sym} 150 -20 0 0 {name=x1}
C {vsource.sym} -250 -60 0 0 {name=Vsuply value="dc \{VDD\} ac \{ac_vdd\}" savecurrent=false}
C {gnd.sym} -250 -10 0 0 {name=l2 lab=0}
C {vsource.sym} -50 70 0 0 {name=Vref value="\{VREF\}" savecurrent=false}
C {gnd.sym} -50 120 0 0 {name=l1 lab=0}
C {gnd.sym} 70 60 0 0 {name=l3 lab=0}
C {vsource.sym} -150 30 0 0 {name=Vin value=\{VIN\} savecurrent=false}
C {gnd.sym} -150 80 0 0 {name=l4 lab=0}
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
C {code_shown.sym} 620 -380 0 0 {name=s1 
only_topleveL=false 
value="


* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.option temp=125
.option num_threads=8

**parametros_ldo
.param VDD = 1.8
.param VREF = 0.6
.param VIN = 1.8
.param RL = 25
.param CL = 1u
.param tsim = 2m
* Parámetros para la prueba de carga del LDO
.param iload_min = 1m
.param iload_max = 50m
.param tstart   = 10u
.param trise    = 100n
.param tfall    = 100n
.param twidth   = 200u
.param tperiod  = 400u
.param tperiod  = 400u
.param tsim = '5*tperiod'

.param ac_iprobe = 1
.param ac_vdd = 0 




.control
let tperiod  = 400u
let tsim = '5*tperiod'

set filetype=ascii

* 1. Punto de Operación (.OP)
op
write LDO_op.raw

* 2. Análisis Transitorio para overshot y undershot (.TRAN)
tran 1u $&tsim
write LDO_tran_picos.raw

* 3. Análisis en Frecuencia  para estabilidad (.AC)
ac dec 10 1 1G
* 1. Ganancia de Lazo Abierto T(s) = v(x1.vre) / v(x1.net3)
let T_loop = v(x1.vre) / v(x1.net3)
let loop_gain_db = vdb(T_loop)
let fase_deg = vp(T_loop) * 180 / pi
write LDO_ac_estability.raw

* 4. Análisis en dc sweep para el load regulation
dc iload 100u 50m 100u
*plot vo
*plot vsense#branch
write LDO_dc_load.raw

* 5. Analisis en dc sweep para el line regulation 
dc vin 1.3 2 0.01
*plot vo
*plot vi
write LDO_dc_line.raw

*6. análisis en Frecuencia (.AC) para el PSRR
alterparam ac_iprobe = 0
alterparam ac_vdd = 1
reset 

ac dec 10 1 1G
* 1. Ganancia de Lazo Abierto T(s) = v(x1.vre) / v(x1.net3)
let psrr1 = v(vdd)/v(vo) 
let psrr_db = vdb(psrr1)

write LDO_ac_psrr.raw





*CALCULOS PARA ESTABILIDAD Y GANANCIA EN LAZO ABIERTO 

setplot ac1
* 2. UGB (Frecuencia donde la magnitud cruza 0 dB)
meas ac ugb WHEN loop_gain_db = 0.0
* 3. Medir la fase en grados en el punto exacto del UGB
meas ac fase_ugb FIND fase_deg WHEN loop_gain_db = 0.0

* 4. Calcular el Margen de Fase (PM = fase_ugb)
let margen_fase = fase_ugb
meas ac ganancia_banda_plana   find loop_gain_db at=1
echo 'margen_fase = $&fase_ugb'

*CALCULOS PARA EL PSRR
setplot ac2
meas ac gananciaPSRR_1   find psrr_db at=1
meas ac gananciaPSRR_1k  find psrr_db at=1k
meas ac gananciaPSRR_10k find psrr_db at=10k
meas ac gananciaPSRR_1M  find psrr_db at=1Meg

*CALCULOS PARA EL LOAD REGULATION         
setplot dc1
meas dc voload_max MAX v(vo)
meas dc voload_min MIN v(vo)
let load_regulation = voload_max - voload_min
echo 'load_regulation = $&load_regulation'

*CALCULOS PARA EL LINE REGULATION 
setplot dc2
meas dc voline_max MAX v(vo)
meas dc voline_min MIN v(vo)
let line_regulation = voline_max - voline_min
echo 'line_regulation = $&line_regulation'


.endc

"
}
