v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 350 -180 440 -180 {lab=Vgp}
N 440 -340 440 -180 {lab=Vgp}
N 270 -130 270 -100 {lab=VSS}
N 270 -50 330 -50 {lab=VSS}
N 80 -380 410 -380 {lab=VIN}
N 120 -150 200 -150 {lab=Vref}
N 80 -150 120 -150 {lab=Vref}
N 330 -50 580 -50 {lab=VSS}
N 580 -140 580 -100 {lab=VSS}
N 580 -230 580 -200 {lab=Vre}
N 580 -380 580 -290 {lab=VOUT}
N 470 -380 580 -380 {lab=VOUT}
N 580 -380 730 -380 {lab=VOUT}
N 420 -50 420 -40 {lab=VSS}
N 440 -470 440 -380 {lab=VDD}
N 520 -260 560 -260 {lab=VSS}
N 520 -170 560 -170 {lab=VSS}
N 70 -210 100 -210 {lab=Vre}
N 160 -210 200 -210 {lab=vre2}
N 580 -220 700 -220 {lab=Vre}
N 700 -280 700 -220 {lab=Vre}
N 700 -380 700 -340 {lab=VOUT}
N 730 -380 870 -380 {lab=VOUT}
N 150 -270 170 -270 {lab=vre2}
N 170 -270 170 -210 {lab=vre2}
N 270 -100 270 -50 {lab=VSS}
N 580 -100 580 -50 {lab=VSS}
N 270 -290 270 -230 {lab=VDD}
N 310 -100 340 -100 {lab=Vgn_bias}
N 310 -150 310 -100 {lab=Vgn_bias}
N 390 -150 460 -150 {lab=VDD}
N 580 -50 830 -50 {lab=VSS}
N 830 -80 830 -50 {lab=VSS}
N 830 -110 880 -110 {lab=VSS}
N 880 -110 880 -50 {lab=VSS}
N 830 -50 880 -50 {lab=VSS}
N 830 -380 830 -140 {lab=VOUT}
N 750 -110 790 -110 {lab=Vgn_bias}
C {ipin.sym} 80 -380 0 0 {name=p1 lab=VIN}
C {iopin.sym} 270 -290 3 0 {name=p3 lab=VDD}
C {opin.sym} 870 -380 0 0 {name=p2 lab=VOUT}
C {lab_wire.sym} 510 -50 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {ipin.sym} 80 -150 0 0 {name=p5 lab=Vref}
C {lab_wire.sym} 70 -210 0 0 {name=p6 sig_type=std_logic lab=Vre}
C {lab_wire.sym} 580 -210 0 0 {name=p7 sig_type=std_logic lab=Vre}
C {iopin.sym} 420 -40 1 0 {name=p8 lab=VSS}
C {lab_wire.sym} 440 -470 0 0 {name=p10 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 520 -260 0 0 {name=p11 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 520 -170 0 0 {name=p12 sig_type=std_logic lab=VSS}
C {vsource.sym} 130 -210 1 0 {name=V1 value="0 ac \{ac_iprobe\}" savecurrent=false}
C {/foss/designs/LDO-sky130/xschem/OTA.sym} 260 -180 0 0 {name=x1}
C {lab_wire.sym} 150 -270 0 0 {name=p13 sig_type=std_logic lab=vre2}
C {lab_wire.sym} 440 -270 0 0 {name=p14 sig_type=std_logic lab=Vgp}
C {sky130_fd_pr/cap_mim_m3_2.sym} 700 -310 0 0 {name=C1 model=cap_mim_m3_2 W=27 L=25 MF=1 spiceprefix=X}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 440 -360 3 0 {name=M1
W=250
L=1
nf=100
mult=3
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} 310 -100 0 1 {name=p16 sig_type=std_logic lab=Vgn_bias}
C {/foss/designs/OSCAR/xschem/Iref/self_bias.sym} 290 -100 0 0 {name=x2}
C {lab_wire.sym} 440 -150 0 1 {name=p9 sig_type=std_logic lab=VDD}
C {sky130_fd_pr/nfet_01v8.sym} 810 -110 0 0 {name=Mnl
W=20
L=0.5
nf=2
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
C {lab_wire.sym} 750 -110 0 0 {name=p15 sig_type=std_logic lab=Vgn_bias}
C {res.sym} 580 -260 0 0 {name=R8
value=\{109k*(1+rsh_var)\}
footprint=1206
device=resistor
m=1}
C {res.sym} 580 -170 0 0 {name=R9
value=\{109k*(1+rsh_var)\}
footprint=1206
device=resistor
m=1}
