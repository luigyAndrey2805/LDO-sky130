v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 280 200 280 240 {lab=VSS}
N 230 170 260 170 {lab=VSS}
N 230 170 230 240 {lab=VSS}
N 280 110 280 140 {lab=VR}
N 280 10 280 50 {lab=Vgp}
N 140 -20 250 -20 {lab=Vgp}
N 210 -20 210 30 {lab=Vgp}
N 210 30 280 30 {lab=Vgp}
N 100 10 100 150 {lab=VDI}
N 100 80 240 80 {lab=VDI}
N 230 240 280 240 {lab=VSS}
N 100 240 230 240 {lab=VSS}
N 100 210 100 240 {lab=VSS}
N -60 240 100 240 {lab=VSS}
N -60 210 -60 240 {lab=VSS}
N -60 30 -60 150 {lab=VDinv}
N -80 90 -60 90 {lab=VDinv}
N -120 120 -120 240 {lab=VSS}
N -120 240 -60 240 {lab=VSS}
N 0 -0 -0 180 {lab=VR}
N -20 180 -0 180 {lab=VR}
N 140 180 180 180 {lab=VR}
N 180 130 180 180 {lab=VR}
N 180 130 280 130 {lab=VR}
N 100 -90 100 -50 {lab=VDD}
N 100 -90 280 -90 {lab=VDD}
N 280 -90 280 -50 {lab=VDD}
N -60 -90 100 -90 {lab=VDD}
N 0 130 180 130 {lab=VR}
N -120 30 -120 60 {lab=Vgp}
N -60 10 -60 30 {lab=VDinv}
N -60 -90 -60 -50 {lab=VDD}
N -20 -20 -0 -20 {lab=VR}
N 0 -20 0 -0 {lab=VR}
N -150 30 -120 30 {lab=Vgp}
N -80 -20 -60 -20 {lab=VDD}
N -80 -90 -80 -20 {lab=VDD}
N -80 -90 -60 -90 {lab=VDD}
N 70 -20 100 -20 {lab=VDD}
N 70 -90 70 -20 {lab=VDD}
N 280 -20 310 -20 {lab=VDD}
N 310 -90 310 -20 {lab=VDD}
N 280 -90 310 -90 {lab=VDD}
N 280 80 350 80 {lab=VSS}
N 70 180 100 180 {lab=VSS}
N 70 180 70 240 {lab=VSS}
N -90 180 -60 180 {lab=VSS}
N -90 180 -90 240 {lab=VSS}
N -160 90 -120 90 {lab=VSS}
N -160 90 -160 240 {lab=VSS}
N -160 240 -120 240 {lab=VSS}
N 180 240 180 280 {lab=VSS}
N 180 -130 180 -90 {lab=VDD}
N 280 130 340 130 {lab=VR}
C {iopin.sym} 340 130 0 0 {name=p2 lab=VR}
C {lab_wire.sym} -10 -90 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 260 -20 0 0 {name=Mp4
W=30
L=1
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
C {sky130_fd_pr/pfet_01v8_lvt.sym} 120 -20 0 1 {name=Mp3
W=30
L=1
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
C {sky130_fd_pr/pfet_01v8_lvt.sym} -40 -20 0 1 {name=Ms2
W=0.5
L=25
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
C {lab_wire.sym} -150 30 0 0 {name=p4 sig_type=std_logic lab=Vgp}
C {lab_wire.sym} 200 -20 0 0 {name=p5 sig_type=std_logic lab=Vgp}
C {lab_wire.sym} 350 80 0 1 {name=p6 sig_type=std_logic lab=VSS
}
C {lab_wire.sym} -20 240 0 1 {name=p7 sig_type=std_logic lab=VSS
}
C {iopin.sym} 180 -130 3 0 {name=p8 lab=VDD}
C {iopin.sym} 180 280 1 0 {name=p9 lab=VSS}
C {lab_wire.sym} 160 80 0 0 {name=p1 sig_type=std_logic lab=VDI}
C {lab_wire.sym} 170 130 0 0 {name=p10 sig_type=std_logic lab=VR}
C {lab_wire.sym} -60 70 0 1 {name=p11 sig_type=std_logic lab=VDinv}
C {sky130_fd_pr/res_iso_pw.sym} 280 170 0 0 {name=R4
W=0.7
L=11
model=res_iso_pw
spiceprefix=X
mult=1}
C {sky130_fd_pr/nfet_01v8.sym} 260 80 0 0 {name=Mn2
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
C {sky130_fd_pr/nfet_01v8.sym} 120 180 0 1 {name=Mn1
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
C {sky130_fd_pr/nfet_01v8.sym} -40 180 0 1 {name=Ms3
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
C {sky130_fd_pr/nfet_01v8.sym} -100 90 0 1 {name=Ms1
W=2
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
