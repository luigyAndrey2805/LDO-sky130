v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {iout = (2/(un*cox*wn/ln)) * (1/rs^2) * (1 - 1/sqrt(k))^2 
tal que k es la relacion de los transistores  	


entonces yo lo veo como

iout = c * (1/rs^2) 

c = iout*rs^2 = 379.5546} -170 -470 0 0 0.2 0.2 {}
N 520 -320 520 -230 {lab=VDD}
N 340 350 340 440 {lab=0}
N 340 440 520 440 {lab=0}
N 520 180 550 180 {lab=0}
N 550 180 550 300 {lab=0}
N 300 180 340 180 {lab=0}
N 300 180 300 300 {lab=0}
N 300 440 340 440 {lab=0}
N 480 -200 520 -200 {lab=VDD}
N 480 -320 480 -200 {lab=VDD}
N 480 -320 520 -320 {lab=VDD}
N 380 180 480 180 {lab=Iref}
N 340 120 340 150 {lab=Iref}
N 420 140 420 180 {lab=Iref}
N 340 140 420 140 {lab=Iref}
N 520 420 520 440 {lab=0}
N 520 440 550 440 {lab=0}
N 340 -320 340 -230 {lab=VDD}
N 340 -320 480 -320 {lab=VDD}
N 520 -170 520 -60 {lab=#net1}
N 520 -0 520 150 {lab=VD}
N 560 -200 590 -200 {lab=#net1}
N 590 -200 590 -130 {lab=#net1}
N 520 -130 590 -130 {lab=#net1}
N 380 -200 430 -200 {lab=#net1}
N 430 -200 430 -150 {lab=#net1}
N 430 -150 520 -150 {lab=#net1}
N 310 -200 340 -200 {lab=VDD}
N 310 -320 310 -200 {lab=VDD}
N 310 -320 340 -320 {lab=VDD}
N 420 440 420 460 {lab=0}
N 220 -230 220 -210 {lab=0}
N 220 -320 220 -290 {lab=VDD}
N 220 -320 310 -320 {lab=VDD}
N 340 20 340 120 {lab=Iref}
N 340 -170 340 -40 {lab=#net2}
N 300 360 300 440 {lab=0}
N 300 300 300 370 {lab=0}
N 340 210 340 350 {lab=0}
N 550 290 550 440 {lab=0}
N 470 390 500 390 {lab=#net3}
N 390 390 410 390 {lab=0}
N 520 210 520 360 {lab=rs}
N 390 390 390 440 {lab=0}
C {lab_wire.sym} 410 140 0 0 {name=p12 sig_type=std_logic lab=Iref}
C {sky130_fd_pr/nfet_01v8.sym} 500 180 0 0 {name=Mc3
W=20
L=1
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 360 180 0 1 {name=Mp2
W=5
L=1
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 540 -200 0 1 {name=Mr
L=0.5
W=2.4
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 360 -200 0 1 {name=Mr1
L=1
W=8
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
}
C {vsource.sym} 520 -30 2 0 {name=Vsense value=0 savecurrent=false}
C {vsource.sym} 220 -260 0 0 {name=VDD value=\{VDD\} savecurrent=false}
C {gnd.sym} 420 460 0 0 {name=l3 lab=0}
C {gnd.sym} 220 -210 0 0 {name=l1 lab=0}
C {code_shown.sym} 730 -330 0 0 {name=s1 
only_topleveL=false 
value="


* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt

**parametros_ota
.param VDD = 1.6
.param rs = 7.8K
.param lr = 0.5


.control

save all
* PMOS

save @m.xMr.msky130_fd_pr__pfet_01v8[gm]
save @m.xMr.msky130_fd_pr__pfet_01v8[gds]
save @m.xMr.msky130_fd_pr__pfet_01v8[id]
save @m.xMr.msky130_fd_pr__pfet_01v8[vgs]
save @m.xMr.msky130_fd_pr__pfet_01v8[vds]
save @m.xMr.msky130_fd_pr__pfet_01v8[vth]
save @m.xMr.msky130_fd_pr__pfet_01v8[vdsat]



* NMOS
save @m.xMc3.msky130_fd_pr__nfet_01v8[gm]
save @m.xMc3.msky130_fd_pr__nfet_01v8[gds]
save @m.xMc3.msky130_fd_pr__nfet_01v8[id]
save @m.xMc3.msky130_fd_pr__nfet_01v8[vgs]
save @m.xMc3.msky130_fd_pr__nfet_01v8[vds]
save @m.xMc3.msky130_fd_pr__nfet_01v8[vth]
save @m.xMc3.msky130_fd_pr__nfet_01v8[vdsat]

set filetype=ascii
op
write iref.raw

dc Rs 1k 20k 100
print vsense#branch
.endc
"
}
C {vsource.sym} 340 -10 2 0 {name=Vsense1 value=0 savecurrent=false}
C {lab_wire.sym} 520 310 0 0 {name=p1 sig_type=std_logic lab=rs}
C {lab_wire.sym} 520 40 0 0 {name=p2 sig_type=std_logic lab=VD}
C {vsource.sym} 440 390 1 0 {name=Vsense2 value=0 savecurrent=false}
C {lab_wire.sym} 390 -320 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {sky130_fd_pr/res_iso_pw.sym} 520 390 0 0 {name=Rs
W=0.44
L=0.35
model=res_iso_pw
spiceprefix=X
mult=1}
