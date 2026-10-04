v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 30 -170 60 -170 {lab=#net1}
N -40 -190 0 -190 {lab=VDD}
N -520 80 -350 80 {lab=VSS}
N -350 -10 -350 80 {lab=VSS}
N -350 -10 -350 80 {lab=VSS}
N -350 80 -70 80 {lab=VSS}
N -70 -10 -70 80 {lab=VSS}
N -480 -420 -250 -420 {lab=VGP}
N -410 -230 -390 -230 {lab=VIN_ota}
N -350 -230 -70 -230 {lab=VDD}
N -350 -320 -350 -260 {lab=Vtail}
N -350 -320 -70 -320 {lab=Vtail}
N -70 -320 -70 -260 {lab=Vtail}
N -210 -390 -210 -320 {lab=Vtail}
N -350 -200 -350 -70 {lab=vd}
N -70 -200 -70 -70 {lab=VO_ota1}
N -70 -170 -30 -170 {lab=VO_ota1}
N 170 -390 170 -130 {lab=VO_ota}
N 120 -170 170 -170 {lab=VO_ota}
N -70 -100 130 -100 {lab=VO_ota1}
N 170 -70 170 80 {lab=VSS}
N -70 80 170 80 {lab=VSS}
N -520 -540 170 -540 {lab=VDD}
N 170 -540 170 -450 {lab=VDD}
N -210 -540 -210 -450 {lab=VDD}
N -30 -230 -20 -230 {lab=VIP_ota}
N -310 -40 -280 -40 {lab=vd}
N -280 -110 -280 -40 {lab=vd}
N -350 -110 -280 -110 {lab=vd}
N -280 -40 -110 -40 {lab=vd}
N -390 -40 -350 -40 {lab=VSS}
N -390 -40 -390 80 {lab=VSS}
N -70 -40 -30 -40 {lab=VSS}
N -30 -40 -30 80 {lab=VSS}
N 170 -420 210 -420 {lab=VDD}
N 210 -540 210 -420 {lab=VDD}
N 170 -540 210 -540 {lab=VDD}
N 170 -100 210 -100 {lab=VSS}
N 210 -100 210 80 {lab=VSS}
N 170 80 210 80 {lab=VSS}
N -210 -420 -180 -420 {lab=VDD}
N -180 -540 -180 -420 {lab=VDD}
N -270 -420 -270 -370 {lab=VGP}
N -270 -370 70 -370 {lab=VGP}
N 70 -420 70 -370 {lab=VGP}
N 70 -420 130 -420 {lab=VGP}
N 170 -220 250 -220 {lab=VO_ota}
N -590 -540 -590 -450 {lab=VDD}
N -770 -10 -770 80 {lab=VSS}
N -770 80 -590 80 {lab=VSS}
N -590 -180 -560 -180 {lab=VSS}
N -560 -180 -560 -60 {lab=VSS}
N -810 -180 -770 -180 {lab=VSS}
N -810 -180 -810 -60 {lab=VSS}
N -810 80 -770 80 {lab=VSS}
N -630 -420 -590 -420 {lab=VDD}
N -630 -540 -630 -420 {lab=VDD}
N -630 -540 -590 -540 {lab=VDD}
N -730 -180 -630 -180 {lab=Viref}
N -770 -240 -770 -210 {lab=Viref}
N -690 -220 -690 -180 {lab=Viref}
N -770 -220 -690 -220 {lab=Viref}
N -590 60 -590 80 {lab=VSS}
N -590 80 -560 80 {lab=VSS}
N -770 -540 -770 -450 {lab=VDD}
N -770 -540 -630 -540 {lab=VDD}
N -550 -420 -520 -420 {lab=VGP}
N -520 -420 -520 -350 {lab=VGP}
N -590 -350 -520 -350 {lab=VGP}
N -730 -420 -680 -420 {lab=VGP}
N -680 -420 -680 -370 {lab=VGP}
N -680 -370 -590 -370 {lab=VGP}
N -800 -420 -770 -420 {lab=VDD}
N -800 -540 -800 -420 {lab=VDD}
N -800 -540 -770 -540 {lab=VDD}
N -810 0 -810 80 {lab=VSS}
N -770 -150 -770 -10 {lab=VSS}
N -640 30 -610 30 {lab=VSS}
N -590 -150 -590 0 {lab=rs}
N -520 -420 -480 -420 {lab=VGP}
N -590 -540 -520 -540 {lab=VDD}
N -640 30 -640 80 {lab=VSS}
N -560 80 -520 80 {lab=VSS}
N -590 -390 -590 -370 {lab=VGP}
N -590 -370 -590 -350 {lab=VGP}
N -770 -390 -770 -240 {lab=Viref}
N -590 -350 -590 -210 {lab=VGP}
N -560 -60 -560 80 {lab=VSS}
N -810 -60 -810 0 {lab=VSS}
C {ipin.sym} -410 -230 0 0 {name=p1 lab=VIN_ota}
C {opin.sym} 250 -220 0 0 {name=p2 lab=VO_ota}
C {lab_wire.sym} 70 80 0 0 {name=p6 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -20 -190 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 170 -340 0 0 {name=p9 sig_type=std_logic lab=VO_ota}
C {lab_wire.sym} -70 -130 0 0 {name=p10 sig_type=std_logic lab=VO_ota1}
C {iopin.sym} -240 80 1 0 {name=p4 lab=VSS}
C {iopin.sym} -250 -540 3 0 {name=p5 lab=VDD}
C {lab_wire.sym} -280 -320 0 0 {name=p13 sig_type=std_logic lab=Vtail}
C {lab_wire.sym} -380 -420 0 0 {name=p14 sig_type=std_logic lab=VGP}
C {sky130_fd_pr/res_high_po.sym} 0 -170 1 0 {name=R1
W=0.35
L=360
model=res_high_po
spiceprefix=X
mult=1}
C {sky130_fd_pr/cap_mim_m3_2.sym} 90 -170 1 0 {name=C1 model=cap_mim_m3_2 W=50 L=50 MF=1 spiceprefix=X}
C {lab_wire.sym} -210 -230 0 0 {name=p15 sig_type=std_logic lab=VDD}
C {sky130_fd_pr/nfet_01v8.sym} -90 -40 0 0 {name=Mpr
W=3
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
C {sky130_fd_pr/nfet_01v8.sym} -330 -40 0 1 {name=Mnr
W=3
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
C {sky130_fd_pr/pfet_01v8.sym} -370 -230 0 0 {name=Mn
W=28
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
C {sky130_fd_pr/pfet_01v8.sym} -50 -230 0 1 {name=Mp
W=28
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
C {sky130_fd_pr/nfet_01v8.sym} 150 -100 0 0 {name=Mo
W=3
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
C {ipin.sym} -20 -230 2 0 {name=p16 lab=VIP_ota}
C {lab_wire.sym} -320 -540 0 0 {name=p17 sig_type=std_logic lab=VDD}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -230 -420 0 0 {name=Mrc1
L=0.5
W=40
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 150 -420 0 0 {name=Mrc2
L=0.5
W=8
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} -700 -220 0 0 {name=p12 sig_type=std_logic lab=Viref}
C {sky130_fd_pr/nfet_01v8.sym} -610 -180 0 0 {name=Mc3
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
C {sky130_fd_pr/nfet_01v8.sym} -750 -180 0 1 {name=Mp2
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
C {sky130_fd_pr/pfet_01v8_lvt.sym} -570 -420 0 1 {name=Mr
L=0.5
W=2.4
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -750 -420 0 1 {name=Mr1
L=1
W=8
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
}
C {lab_wire.sym} -720 -540 0 0 {name=p18 sig_type=std_logic lab=VDD}
C {sky130_fd_pr/res_iso_pw.sym} -590 30 0 0 {name=Rs
W=0.425
L=0.35
model=res_iso_pw
spiceprefix=X
mult=1}
C {lab_wire.sym} -590 -70 0 0 {name=p8 sig_type=std_logic lab=rs}
C {lab_wire.sym} -200 -40 0 0 {name=p11 sig_type=std_logic lab=vd}
