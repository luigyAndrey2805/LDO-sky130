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
C {vsource.sym} -30 -20 0 1 {name=V1 value="dc \{VDD\} ac 0 pulse(0 \{VDD\} 2u 10u 10u 40u 100u)" savecurrent=false}
C {lab_wire.sym} 40 -90 0 0 {name=p1 sig_type=std_logic lab=VDD
}
C {lab_wire.sym} 10 -20 0 0 {name=p2 sig_type=std_logic lab=VR}
C {code_shown.sym} 300 -210 0 0 {name=s1
only_topleveL=false 
value="


* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice ss
.option temp=-40
.option num_threads=8

**parametros_ldo
.param VDD = 1.62



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



* Ms2 (pfet_01v8_lvt)
save @m.x1.xMs2.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.xMs2.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.xMs2.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.xMs2.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.xMs2.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.xMs2.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.xMs2.msky130_fd_pr__pfet_01v8_lvt[vdsat]

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

tran 2u 300u

meas tran vr_tan FIND v(vr) at=30u


let vr_tran = 'vr_tan'

echo vr_tran = $&vr_tran
.endc

"
}
C {self_bias.sym} -10 -20 0 0 {name=x1}
