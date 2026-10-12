v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -420 -90 -420 -70 {lab=0}
N -220 40 -220 60 {lab=0}
N -220 -50 -220 -20 {lab=vref}
N -320 70 -320 90 {lab=0}
N -320 -90 -320 -60 {lab=vi}
N -320 -100 -170 -100 {lab=vi}
N -320 -100 -320 -90 {lab=vi}
N -220 -60 -220 -50 {lab=vref}
N -220 -60 -170 -60 {lab=vref}
N -100 -30 -100 0 {lab=0}
N -100 -180 -100 -130 {lab=VDD}
N -420 -170 -420 -150 {lab=VDD}
N 90 -10 90 20 {lab=#net1}
N 90 -100 90 -70 {lab=vo}
N -40 -100 30 -100 {lab=vo}
N -420 -180 -420 -170 {lab=VDD}
N -420 -180 -100 -180 {lab=VDD}
N 180 -10 180 20 {lab=0}
N 90 -100 180 -100 {lab=vo}
N 180 -100 180 -70 {lab=vo}
N 30 -100 90 -100 {lab=vo}
N -320 0 -320 10 {lab=#net2}
N 90 80 90 100 {lab=0}
N 0 -100 -0 -80 {lab=vo}
N 0 -20 0 10 {lab=#net1}
N -0 10 90 10 {lab=#net1}
C {vsource.sym} -420 -120 0 0 {name=Vsuply value="dc \{VDD\} ac \{ac_vdd\}" savecurrent=false}
C {gnd.sym} -420 -70 0 0 {name=l2 lab=0}
C {vsource.sym} -220 10 0 0 {name=Vref value="\{VREF\}" savecurrent=false}
C {gnd.sym} -220 60 0 0 {name=l1 lab=0}
C {gnd.sym} -100 0 0 0 {name=l3 lab=0}
C {vsource.sym} -320 40 0 0 {name=Vin value=\{VIN\} savecurrent=false}
C {gnd.sym} -320 90 0 0 {name=l4 lab=0}
C {res.sym} 90 -40 0 0 {name=R1
value=\{RL\}
footprint=1206
device=resistor
m=1}
C {gnd.sym} 90 100 0 0 {name=l5 lab=0}
C {capa-2.sym} 180 -40 0 0 {name=C1
m=1
value=\{CL\}
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 180 20 0 0 {name=l6 lab=0}
C {lab_wire.sym} -220 -100 0 0 {name=p1 sig_type=std_logic lab=vi}
C {lab_wire.sym} 140 -100 0 0 {name=p2 sig_type=std_logic lab=vo}
C {lab_wire.sym} -220 -60 0 0 {name=p3 sig_type=std_logic lab=vref}
C {vsource.sym} 90 50 0 0 {name=Vsense value=0 savecurrent=false}
C {lab_wire.sym} -220 -180 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {vsource.sym} -320 -30 2 0 {name=Vin1 value="dc 0 ac 0 " savecurrent=false}
C {/foss/designs/LDO-sky130/xschem/LDO.sym} -20 -80 0 0 {name=x1}
C {code_shown.sym} 590 -640 0 0 {name=s3
only_topleveL=false 
value="


* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.option temp=125
.option num_threads=8

**parametros_ldo
.param VDD = 1.8
.param VREF = 0.6
.param VIN = '1*VDD'
.param RL = 1e6
.param CL = 1u
.param tsim = 2m
* Parámetros para la prueba de carga del LDO
.param iload_min = 1u
.param iload_max = 50m
.param tstart   = 10u
.param trise    = 100n
.param tfall    = 100n
.param twidth   = 100u
.param tperiod  = 200u

.param tsim = '3*tperiod'
.param ac_iprobe = 1
.param ac_vdd = 0 


.control
let tperiod  = 200u
let tsim = '3*tperiod'
op
tran 1u $&tsim
* 4. Análisis en dc sweep para el load regulation
*dc r1 24 5000 10
plot vo
plot vsense#branch

meas dc voload_max MAX v(vo)
meas dc voload_min MIN v(vo)
let load_regulation = voload_max - voload_min
echo 'load_regulation = $&load_regulation'

.endc

"
}
C {isource.sym} 0 -50 0 0 {name=Iload value="PWL(0 0 1m 100m)"}
