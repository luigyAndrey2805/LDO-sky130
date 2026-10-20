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
N 10 -20 40 -20 {lab=VR}
C {gnd.sym} 90 100 0 0 {name=l1 lab=0}
C {vsource.sym} -30 -20 0 1 {name=V1 value="dc \{VDD\} ac 0 PWL(0 0 10m 0 10.1m \{VDD\} 50m \{VDD\} 50.1m 0 100m 0 101m \{VDD\} 150m \{VDD\} 150.1m 0 200m 0 300m \{VDD\} 400m \{VDD\} 400.1m 0)"}
C {lab_wire.sym} 40 -90 0 0 {name=p1 sig_type=std_logic lab=VDD
}
C {lab_wire.sym} 10 -20 0 0 {name=p2 sig_type=std_logic lab=VR}
C {code_shown.sym} 300 -210 0 0 {name=s1
only_topleveL=false 
value="

**dc \{VDD\} ac 0 pulse(0 \{VDD\} 2u 10u 10u 40u 100u)
* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice ss_ll

.include /foss/designs/LDO-sky130/xschem/Iref/self_bias_pex.spice

.option temp=27
.option num_threads=8

**parametros_ldo
.param VDD = 1.98



.param tstart   = 10u
.param trise    = 200u
.param tfall    = 200u

.param tsim = 'tstart+2*trise+tfall'



.control
let tstart   = 10u
let trise    = 200u
let tfall    = 200u

let tsim = '$&tstart+4*$&trise+3*$&tfall'

*save all








set filetype=ascii
op
write self_bias_tb.raw


tran 2u 400.1m

* --- 3. Mediciones del Start-up ---
  * Midiendo voltaje vr justo antes de que el pulso respectivo se apague
  
  * Para Trise = 100us (Pulso activo entre 10m y 50m)
  meas tran vr_100us FIND v(vr) at=40m

  * Para Trise = 1ms (Pulso activo entre 100m y 150m)
  meas tran vr_1ms FIND v(vr) at=140m

  * Para Trise = 100ms (Pulso activo entre 200m y 400m)
  meas tran vr_100ms FIND v(vr) at=390m


.endc

"
}
C {self_bias.sym} -10 -20 0 0 {name=x1 lvs_ignore=true }
