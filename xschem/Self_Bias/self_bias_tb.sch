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
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt

*.include /foss/designs/LDO-sky130/xschem/Iref/self_bias_pex.spice

.option temp=27
.option num_threads=8

**parametros_ldo
.param VDD = 1.8



.param tstart   = 10u
.param trise    = 200u
.param tfall    = 200u

.param tsim = 'tstart+2*trise+tfall'



.control
let tstart   = 10u
let trise    = 200u
let tfall    = 200u

let tsim = '$&tstart+4*$&trise+3*$&tfall'

save all





* Mp3 (pfet_01v8_lvt)
save @m.x1.xMp3.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.xMp3.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.xMp3.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.xMp3.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.xMp3.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.xMp3.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.xMp3.msky130_fd_pr__pfet_01v8_lvt[vdsat]

* Mp4 (pfet_01v8_lvt)
save @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[vdsat]



*Ms1 (nfet_01v8)
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[vdsat]

*Ms3 (nfet_01v8)
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[vdsat]

*Mn1 (nfet_01v8)
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[vdsat]

*Mn2 (nfet_01v8)
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[vdsat]



set filetype=ascii
op
write self_bias_tb.raw

* 1. Calculamos y guardamos los valores
let vr = v(vr) 
let ibias_val_uA_op = '(@m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id])*1000000'


* 2. Imprimimos el texto junto con el valor de la variable
echo VR = $&vr
echo ibias = $&ibias_val_uA_op

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
C {/foss/designs/LDO-sky130/xschem/Self_Bias/self_bias.sym} -10 -20 0 0 {name=x1}
