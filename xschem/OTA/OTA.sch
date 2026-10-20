v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 30 -170 60 -170 {lab=vmiler}
N -40 -190 0 -190 {lab=VSS}
N -350 -10 -350 80 {lab=VSS}
N -350 -10 -350 80 {lab=VSS}
N -350 80 -70 80 {lab=VSS}
N -70 -10 -70 80 {lab=VSS}
N -410 -230 -390 -230 {lab=VIN_ota}
N -350 -230 -70 -230 {lab=VDD}
N -350 -320 -350 -260 {lab=vtail}
N -350 -320 -70 -320 {lab=vtail}
N -70 -320 -70 -260 {lab=vtail}
N -210 -390 -210 -320 {lab=vtail}
N -350 -200 -350 -70 {lab=vd}
N -70 -200 -70 -70 {lab=vo1}
N -70 -170 -30 -170 {lab=vo1}
N 170 -390 170 -130 {lab=VO_ota}
N 120 -170 170 -170 {lab=VO_ota}
N -70 -100 130 -100 {lab=vo1}
N 170 -70 170 80 {lab=VSS}
N -70 80 170 80 {lab=VSS}
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
N -270 -420 -270 -370 {lab=vgp}
N -270 -370 70 -370 {lab=vgp}
N 70 -420 70 -370 {lab=vgp}
N 70 -420 130 -420 {lab=vgp}
N 170 -220 250 -220 {lab=VO_ota}
N -390 80 -350 80 {lab=VSS}
N -210 -540 170 -540 {lab=VDD}
N -330 -420 -250 -420 {lab=vgp}
N -210 -420 -140 -420 {lab=VDD}
N -140 -540 -140 -420 {lab=VDD}
N -560 -10 -560 80 {lab=VSS}
N -560 80 -390 80 {lab=VSS}
N -560 -40 -510 -40 {lab=VSS}
N -510 -40 -510 80 {lab=VSS}
N -560 -400 -560 -70 {lab=vgp}
N -560 -530 -560 -450 {lab=VDD}
N -560 -540 -560 -530 {lab=VDD}
N -560 -540 -210 -540 {lab=VDD}
N -520 -420 -330 -420 {lab=vgp}
N -560 -350 -490 -350 {lab=vgp}
N -490 -420 -490 -350 {lab=vgp}
N -580 -420 -560 -420 {lab=VDD}
N -580 -540 -580 -420 {lab=VDD}
N -580 -540 -560 -540 {lab=VDD}
N -650 -40 -600 -40 {lab=VGN}
C {ipin.sym} -410 -230 0 0 {name=p1 lab=VIN_ota}
C {opin.sym} 250 -220 0 0 {name=p2 lab=VO_ota}
C {lab_wire.sym} 70 80 0 0 {name=p6 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -20 -190 0 0 {name=p7 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 170 -340 0 0 {name=p9 sig_type=std_logic lab=VO_ota}
C {lab_wire.sym} -70 -130 0 0 {name=p10 sig_type=std_logic lab=vo1}
C {iopin.sym} -240 80 1 0 {name=p4 lab=VSS}
C {iopin.sym} -50 -540 3 0 {name=p5 lab=VDD}
C {lab_wire.sym} -280 -320 0 0 {name=p13 sig_type=std_logic lab=vtail}
C {lab_wire.sym} -50 -370 0 0 {name=p14 sig_type=std_logic lab=vgp}
C {lab_wire.sym} -210 -230 0 0 {name=p15 sig_type=std_logic lab=VDD}
C {sky130_fd_pr/nfet_01v8.sym} -90 -40 0 0 {name=Mpr
W=6
L=1
nf=4
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
W=6
L=1
nf=4
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
C {sky130_fd_pr/nfet_01v8.sym} 150 -100 0 0 {name=Mo
W=8
L=2
nf=8
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
C {lab_wire.sym} 150 -540 0 0 {name=p17 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -200 -40 0 0 {name=p11 sig_type=std_logic lab=vd}
C {iopin.sym} -650 -40 2 0 {name=p3 lab=VGN}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 150 -420 0 0 {name=Mrc2
L=2
W=50
nf=8
mult=1
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/cap_mim_m3_2.sym} 90 -170 1 0 {name=C1 model=cap_mim_m3_2 W=35 L=71.36 MF=1 spiceprefix=X}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -50 -230 0 1 {name=Mp
L=1
W=26
nf=4
mult=1
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -370 -230 0 0 {name=Mn
L=1
W=26
nf=4
mult=1
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -230 -420 0 0 {name=Mrc1
L=1
W=50
nf=8
mult=1
modeL=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -540 -420 0 1 {name=Mr
L=1
W=12.5
nf=2
mult=1
modeL=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -580 -40 0 0 {name=Mnref
W=8
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
C {sky130_fd_pr/res_xhigh_po_0p35.sym} 0 -170 1 0 {name=R10
W=0.35
L=90.72
model=res_xhigh_po_0p35
spiceprefix=X
 mult=1}
C {lab_wire.sym} 50 -170 0 0 {name=p8 sig_type=std_logic lab=vmiler}
