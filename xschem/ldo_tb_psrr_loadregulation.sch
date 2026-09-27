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
C {vsource.sym} -250 -60 0 0 {name=Vsuply value="\{VDD\} ac \{ac_vdd\}" savecurrent=false}
C {gnd.sym} -250 -10 0 0 {name=l2 lab=0}
C {vsource.sym} -50 70 0 0 {name=Vref value="\{VREF\}" savecurrent=false}
C {gnd.sym} -50 120 0 0 {name=l1 lab=0}
C {gnd.sym} 70 60 0 0 {name=l3 lab=0}
C {vsource.sym} -150 30 0 0 {name=Vin value="DC 1.8 AC 0 "  savecurrent=false}
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
C {isource.sym} 160 0 0 0 {name=Iload value="dc 50m ac 0 PWL(0 \{iload_min\} \{tsim\} \{iload_max\}) dc 50m" savecurrent=true}
C {vsource.sym} 200 70 1 0 {name=Vsense value=0 savecurrent=false}
C {lab_wire.sym} -50 -120 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {code_shown.sym} 620 -380 0 0 {name=s1 
only_topleveL=false 
value="


* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice ss

**parametros_ldo

.param ac_iprobe = 0
.param ac_vdd = 1

.param VDD = 1.8
.param VREF = 0.6
.param VIN = 1.8
.param RL = 999k
.param CL = 1u
.param tsim = 2m
* Parámetros para la prueba de carga del LDO
.param iload_min = 100u
.param iload_max = 50m
.param tstart   = 10u
.param trise    = 100n
.param tfall    = 100n
.param twidth   = 200u
.param tperiod  = 400u
.param tsim = '5*tperiod'

.control
let tperiod  = 400u
let tsim = '5*tperiod'


set filetype=ascii

* Punto de Operación (.OP)
op
write LDO_op.raw

* Análisis en dc sweep para el load regulation
dc iload 100u 50m 100u
*plot vo
*plot vsense#branch

* Analisis en dc sweep para el line regulation 
dc vin 1.3 2 0.01
*plot vo
*plot vi

write LDO_trans.raw

*análisis en Frecuencia (.AC) para el PSRR
ac dec 10 1 1G
write LDO_ac.raw

* 1. Ganancia de Lazo Abierto T(s) = v(x1.vre) / v(x1.net3)
let psrr1 = v(vdd)/v(vo) 
let psrr_db = vdb(psrr1)

* 5. Graficar la magnitud
*plot psrr_db


setplot ac1
meas ac ganancia_1   find psrr_db at=1
meas ac ganancia_1k  find psrr_db at=1k
meas ac ganancia_10k find psrr_db at=10k
meas ac ganancia_1M  find psrr_db at=1Meg

        
setplot dc1
meas dc voload_max MAX v(vo)
meas dc voload_min MIN v(vo)
let load_regulation = voload_max - voload_min
echo 'load_regulation = $&load_regulation'

setplot dc2
meas dc voline_max MAX v(vo)
meas dc voline_min MIN v(vo)
let line_regulation = voline_max - voline_min
echo 'line_regulation = $&line_regulation'

.endc

"
}
