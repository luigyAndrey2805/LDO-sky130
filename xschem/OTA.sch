v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -560 90 -290 90 {lab=Iref}
N -600 10 -600 60 {lab=Iref}
N -600 30 -530 30 {lab=Iref}
N -530 30 -530 90 {lab=Iref}
N -600 120 -600 190 {lab=VSS}
N -600 190 130 190 {lab=VSS}
N 130 120 130 190 {lab=VSS}
N -250 120 -250 190 {lab=VSS}
N -660 90 -600 90 {lab=VSS}
N -660 90 -660 190 {lab=VSS}
N -660 190 -600 190 {lab=VSS}
N -250 90 -190 90 {lab=VSS}
N -190 90 -190 190 {lab=VSS}
N 130 90 180 90 {lab=VSS}
N 180 90 180 190 {lab=VSS}
N 130 190 180 190 {lab=VSS}
N -250 10 -250 60 {lab=Vtail}
N -370 10 -250 10 {lab=Vtail}
N -370 -50 -370 10 {lab=Vtail}
N -250 10 -160 10 {lab=Vtail}
N -160 -50 -160 10 {lab=Vtail}
N -370 -230 -370 -110 {lab=VGP}
N -160 -230 -160 -110 {lab=VO_ota}
N 130 -180 130 60 {lab=VO_ota}
N -370 -380 -370 -290 {lab=VDD}
N -370 -380 130 -380 {lab=VDD}
N 130 -380 130 -240 {lab=VDD}
N -160 -380 -160 -290 {lab=VDD}
N -330 -260 -200 -260 {lab=VGP}
N -160 -210 90 -210 {lab=VO_ota}
N -370 -80 -160 -80 {lab=VSS}
N -160 -260 -110 -260 {lab=VDD}
N -110 -380 -110 -260 {lab=VDD}
N -430 -260 -370 -260 {lab=VDD}
N -430 -380 -430 -260 {lab=VDD}
N -430 -380 -370 -380 {lab=VDD}
N 130 -210 190 -210 {lab=VDD}
N 190 -380 190 -210 {lab=VDD}
N 130 -380 190 -380 {lab=VDD}
N -350 40 -350 90 {lab=Iref}
N -350 40 30 40 {lab=Iref}
N 30 40 30 90 {lab=Iref}
N 30 90 90 90 {lab=Iref}
N -290 -260 -290 -200 {lab=VGP}
N -370 -200 -290 -200 {lab=VGP}
N -120 -80 -100 -80 {lab=VIP_ota}
N -430 -80 -410 -80 {lab=VIN_ota}
N -600 -20 -600 10 {lab=Iref}
N -90 -410 -90 -380 {lab=VDD}
N -290 190 -290 220 {lab=VSS}
N 130 -150 220 -150 {lab=VO_ota}
C {ipin.sym} -430 -80 0 0 {name=p1 lab=VIN_ota}
C {opin.sym} 220 -150 0 0 {name=p2 lab=VO_ota}
C {iopin.sym} -600 -20 3 0 {name=p3 lab=Iref}
C {sky130_fd_pr/nfet_01v8.sym} -580 90 0 1 {name=Mr
W=1
L=0.15
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
C {sky130_fd_pr/pfet_01v8.sym} 110 -210 0 0 {name=Mo
W=1
L=0.15
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
C {sky130_fd_pr/nfet_01v8.sym} -270 90 0 0 {name=Mrc1
W=1
L=0.15
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
C {sky130_fd_pr/nfet_01v8.sym} 110 90 0 0 {name=Mc2
W=1
L=0.15
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
C {sky130_fd_pr/nfet_01v8.sym} -390 -80 0 0 {name=Mn
W=1
L=0.15
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
C {sky130_fd_pr/nfet_01v8.sym} -140 -80 0 1 {name=Mp
W=1
L=0.15
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
C {lab_wire.sym} -470 190 0 0 {name=p6 sig_type=std_logic lab=VSS}
C {lab_wire.sym} -270 -380 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -260 -80 0 0 {name=p8 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 130 -70 0 0 {name=p9 sig_type=std_logic lab=VO_ota}
C {lab_wire.sym} -160 -160 0 0 {name=p10 sig_type=std_logic lab=VO_ota}
C {sky130_fd_pr/pfet_01v8.sym} -180 -260 0 0 {name=Mpr
W=1
L=0.15
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
C {sky130_fd_pr/pfet_01v8.sym} -350 -260 0 1 {name=Mnr
W=1
L=0.15
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
C {iopin.sym} -290 220 1 0 {name=p4 lab=VSS}
C {iopin.sym} -90 -410 3 0 {name=p5 lab=VDD}
C {ipin.sym} -100 -80 2 0 {name=p11 lab=VIP_ota}
C {lab_wire.sym} -430 90 0 0 {name=p12 sig_type=std_logic lab=Iref}
C {lab_wire.sym} -290 10 0 0 {name=p13 sig_type=std_logic lab=Vtail}
C {lab_wire.sym} -220 -260 0 0 {name=p14 sig_type=std_logic lab=VGP}
