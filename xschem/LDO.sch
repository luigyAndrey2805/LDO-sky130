v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 240 -360 240 -330 {lab=VDD}
N 240 -270 240 -250 {lab=#net1}
N 270 -250 270 -230 {lab=VDD}
N 270 -250 290 -250 {lab=VDD}
N 290 -360 290 -250 {lab=VDD}
N 350 -180 440 -180 {lab=#net2}
N 440 -340 440 -180 {lab=#net2}
N 270 -130 270 -100 {lab=VSS}
N 270 -100 330 -100 {lab=VSS}
N 240 -360 290 -360 {lab=VDD}
N 80 -380 410 -380 {lab=VIN}
N 120 -150 200 -150 {lab=Vref}
N 80 -150 120 -150 {lab=Vref}
N 110 -210 200 -210 {lab=Vre}
N 330 -100 580 -100 {lab=VSS}
N 580 -140 580 -100 {lab=VSS}
N 580 -230 580 -200 {lab=Vre}
N 580 -380 580 -290 {lab=VOUT}
N 470 -380 580 -380 {lab=VOUT}
N 580 -380 730 -380 {lab=VOUT}
N 290 -310 310 -310 {lab=VDD}
N 420 -100 420 -90 {lab=VSS}
C {/foss/designs/LDO-sky130/xschem/OTA.sym} 260 -180 0 0 {name=x1}
C {isource.sym} 240 -300 0 0 {name=I0 value=10u}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 440 -360 3 0 {name=M1
W=1
L=0.35
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {ipin.sym} 80 -380 0 0 {name=p1 lab=VIN}
C {iopin.sym} 310 -310 0 0 {name=p3 lab=VDD}
C {opin.sym} 730 -380 0 0 {name=p2 lab=VOUT}
C {lab_wire.sym} 330 -100 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {ipin.sym} 80 -150 0 0 {name=p5 lab=Vref}
C {lab_wire.sym} 140 -210 0 0 {name=p6 sig_type=std_logic lab=Vre}
C {sky130_fd_pr/res_iso_pw.sym} 580 -260 0 0 {name=R1
W=2.65
L=2.65
model=res_iso_pw
spiceprefix=X
mult=1}
C {sky130_fd_pr/res_iso_pw.sym} 580 -170 0 0 {name=R2
W=2.65
L=2.65
model=res_iso_pw
spiceprefix=X
mult=1}
C {lab_wire.sym} 580 -210 0 0 {name=p7 sig_type=std_logic lab=Vre}
C {iopin.sym} 420 -90 1 0 {name=p8 lab=VSS}
