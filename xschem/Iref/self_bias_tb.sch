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
N 140 -20 190 -20 {lab=Vgp}
C {gnd.sym} 90 100 0 0 {name=l1 lab=0}
C {vsource.sym} -30 -20 0 1 {name=V1 value="dc \{VDD\} ac 0 PWL(0 0 \{tstart\} 0 \{tstart+trise\} 1.8 \{tstart+2*trise\} 1.8 \{tstart+2*trise+tfall\}  0 \{tstart+2*trise+2*tfall\}  0 \{tstart+3*trise+2*tfall\}  1.8  \{tstart+4*trise+2*tfall\}  1.8 \{tstart+4*trise+3*tfall\}  0 )" savecurrent=fals}
C {lab_wire.sym} 40 -90 0 0 {name=p1 sig_type=std_logic lab=VDD
}
C {lab_wire.sym} 190 -20 0 0 {name=p2 sig_type=std_logic lab=Vgp}
C {code_shown.sym} 300 -210 0 0 {name=s1
only_topleveL=false 
value="


* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt
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

* Ms1 (nfet_01v8)
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMs1.msky130_fd_pr__nfet_01v8[vdsat]

* Ms3 (nfet_01v8)
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMs3.msky130_fd_pr__nfet_01v8[vdsat]

* Mn1 (nfet_01v8)
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMn1.msky130_fd_pr__nfet_01v8[vdsat]

* Mn2 (nfet_01v8)
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMn2.msky130_fd_pr__nfet_01v8[vdsat]




set filetype=ascii
op
write self_bias_op.raw


* 1. Calculamos y guardamos los valores
let vsg_val = v(vdd) - v(vgp) 
let ibias_val_uA = '(@m.x1.xMp4.msky130_fd_pr__pfet_01v8_lvt[id])*1000000'

* 2. Imprimimos el texto junto con el valor de la variable
echo VSGP = $&vsg_val
echo ibias = $&ibias_val_uA

tran $&tstart $&tsim


.endc

"
}
C {self_bias.sym} -10 -20 0 0 {name=x1}
