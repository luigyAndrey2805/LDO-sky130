v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -40 -150 -10 -150 {lab=#net1}
N -110 -170 -70 -170 {lab=VDD}
N -590 10 -590 100 {lab=VSS}
N -590 100 -420 100 {lab=VSS}
N -420 10 -420 100 {lab=VSS}
N -420 10 -420 100 {lab=VSS}
N -420 100 -140 100 {lab=VSS}
N -140 10 -140 100 {lab=VSS}
N -590 -370 -590 -50 {lab=VGP}
N -550 -400 -320 -400 {lab=VGP}
N -590 -330 -520 -330 {lab=VGP}
N -520 -400 -520 -330 {lab=VGP}
N -480 -210 -460 -210 {lab=VIN_ota}
N -420 -210 -140 -210 {lab=VDD}
N -420 -300 -420 -240 {lab=Vtail}
N -420 -300 -140 -300 {lab=Vtail}
N -140 -300 -140 -240 {lab=Vtail}
N -280 -370 -280 -300 {lab=Vtail}
N -420 -180 -420 -50 {lab=#net2}
N -140 -180 -140 -50 {lab=VO_ota1}
N -140 -150 -100 -150 {lab=VO_ota1}
N 100 -370 100 -110 {lab=VO_ota}
N 50 -150 100 -150 {lab=VO_ota}
N -140 -80 60 -80 {lab=VO_ota1}
N 100 -50 100 100 {lab=VSS}
N -140 100 100 100 {lab=VSS}
N -590 -520 -590 -430 {lab=VDD}
N -590 -520 100 -520 {lab=VDD}
N 100 -520 100 -430 {lab=VDD}
N -280 -520 -280 -430 {lab=VDD}
N -100 -210 -90 -210 {lab=VIP_ota}
N -770 10 -770 100 {lab=VSS}
N -770 100 -590 100 {lab=VSS}
N -380 -20 -350 -20 {lab=#net2}
N -350 -90 -350 -20 {lab=#net2}
N -420 -90 -350 -90 {lab=#net2}
N -350 -20 -180 -20 {lab=#net2}
N -460 -20 -420 -20 {lab=VSS}
N -460 -20 -460 100 {lab=VSS}
N -140 -20 -100 -20 {lab=VSS}
N -100 -20 -100 100 {lab=VSS}
N -590 -20 -560 -20 {lab=VSS}
N -560 -20 -560 100 {lab=VSS}
N -810 -20 -770 -20 {lab=VSS}
N -810 -20 -810 100 {lab=VSS}
N -810 100 -770 100 {lab=VSS}
N -630 -400 -590 -400 {lab=VDD}
N -630 -520 -630 -400 {lab=VDD}
N -630 -520 -590 -520 {lab=VDD}
N 100 -400 140 -400 {lab=VDD}
N 140 -520 140 -400 {lab=VDD}
N 100 -520 140 -520 {lab=VDD}
N 100 -80 140 -80 {lab=VSS}
N 140 -80 140 100 {lab=VSS}
N 100 100 140 100 {lab=VSS}
N -280 -400 -250 -400 {lab=VDD}
N -250 -520 -250 -400 {lab=VDD}
N -340 -400 -340 -350 {lab=VGP}
N -340 -350 0 -350 {lab=VGP}
N 0 -400 0 -350 {lab=VGP}
N 0 -400 60 -400 {lab=VGP}
N -730 -20 -630 -20 {lab=Iref}
N -770 -80 -770 -50 {lab=Iref}
N -690 -60 -690 -20 {lab=Iref}
N -770 -60 -690 -60 {lab=Iref}
N 100 -200 180 -200 {lab=VO_ota}
C {ipin.sym} -480 -210 0 0 {name=p1 lab=VIN_ota}
C {opin.sym} 180 -200 0 0 {name=p2 lab=VO_ota}
C {iopin.sym} -770 -80 3 0 {name=p3 lab=Iref}
C {lab_wire.sym} 0 100 0 0 {name=p6 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -90 -170 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -670 100 0 0 {name=p8 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 100 -320 0 0 {name=p9 sig_type=std_logic lab=VO_ota}
C {lab_wire.sym} -140 -110 0 0 {name=p10 sig_type=std_logic lab=VO_ota1}
C {iopin.sym} -310 100 1 0 {name=p4 lab=VSS}
C {iopin.sym} -320 -520 3 0 {name=p5 lab=VDD}
C {lab_wire.sym} -700 -60 0 0 {name=p12 sig_type=std_logic lab=Iref}
C {lab_wire.sym} -350 -300 0 0 {name=p13 sig_type=std_logic lab=Vtail}
C {lab_wire.sym} -450 -400 0 0 {name=p14 sig_type=std_logic lab=VGP}
C {sky130_fd_pr/res_high_po.sym} -70 -150 1 0 {name=R1
W=0.35
L=360
model=res_high_po
spiceprefix=X
mult=1}
C {sky130_fd_pr/cap_mim_m3_2.sym} 20 -150 1 0 {name=C1 model=cap_mim_m3_2 W=50 L=50 MF=1 spiceprefix=X}
C {lab_wire.sym} -280 -210 0 0 {name=p15 sig_type=std_logic lab=VDD}
C {sky130_fd_pr/pfet_01v8.sym} -570 -400 0 1 {name=Mnr1
W=2
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -160 -20 0 0 {name=Mc1
W=1
L=0.5
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
C {sky130_fd_pr/nfet_01v8.sym} -400 -20 0 1 {name=Mp1
W=40
L=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} -300 -400 0 0 {name=Mpr1
W=40
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 80 -400 0 0 {name=Mpr2
W=40
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -440 -210 0 0 {name=Mpr3
W=40
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -120 -210 0 1 {name=Mnr2
W=40
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 80 -80 0 0 {name=Mc2
W=1
L=0.5
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
C {sky130_fd_pr/nfet_01v8.sym} -610 -20 0 0 {name=Mc3
W=1
L=0.5
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
C {sky130_fd_pr/nfet_01v8.sym} -750 -20 0 1 {name=Mp2
W=1
L=0.5
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
C {ipin.sym} -90 -210 2 0 {name=p16 lab=VIP_ota}
C {lab_wire.sym} -390 -520 0 0 {name=p17 sig_type=std_logic lab=VDD}
