v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 297.5 55 297.5 90 {lab=#net1}
N 206.25 90 297.5 90 {lab=#net1}
N 297.5 -33.75 297.5 -6.25 {lab=#net2}
N 207.5 -61.25 257.5 -61.25 {lab=#net2}
N 166.25 -32.5 166.25 58.75 {lab=#net3}
N 166.25 25 256.25 25 {lab=#net3}
N 232.5 -105 297.5 -105 {lab=VDD}
N 297.5 -105 297.5 -92.5 {lab=VDD}
N 166.25 -105 232.5 -105 {lab=VDD}
N 166.25 -105 166.25 -92.5 {lab=VDD}
N 257.5 -61.25 257.5 -22.5 {lab=#net2}
N 257.5 -22.5 297.5 -22.5 {lab=#net2}
N 166.25 150 297.5 150 {lab=0}
N 166.25 121.25 166.25 150 {lab=0}
N 133.75 150 166.25 150 {lab=0}
N 133.75 150 133.75 163.75 {lab=0}
N 277.5 121.25 277.5 150 {lab=0}
N 15 150 133.75 150 {lab=0}
N 15 20 15 88.75 {lab=#net4}
N 55 -10 55 118.75 {lab=#net5}
N -58.75 150 13.75 150 {lab=#net6}
N -58.75 85 -58.75 150 {lab=#net6}
N 16.25 -105 166.25 -105 {lab=VDD}
N 16.25 -105 16.25 -41.25 {lab=VDD}
N 206.25 47.5 206.25 88.75 {lab=#net5}
N 55 47.5 206.25 47.5 {lab=#net5}
N -18.75 53.75 15 53.75 {lab=#net4}
N -58.75 -61.25 -58.75 23.75 {lab=#net2}
N -58.75 -61.25 68.75 -61.25 {lab=#net2}
N 68.75 -61.25 68.75 -22.5 {lab=#net2}
N 68.75 -22.5 257.5 -22.5 {lab=#net2}
N 257.5 -23.75 257.5 -22.5 {lab=#net2}
C {sky130_fd_pr/nfet_01v8.sym} 186.25 90 0 1 {name=M1
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
C {sky130_fd_pr/pfet_01v8.sym} 277.5 -62.5 0 0 {name=M22
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
C {sky130_fd_pr/res_high_po.sym} 297.5 120 0 0 {name=R5
W=0.35
L=64
model=res_high_po
spiceprefix=X
mult=1}
C {sky130_fd_pr/nfet_01v8.sym} 277.5 25 0 0 {name=M2
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
C {sky130_fd_pr/nfet_01v8.sym} 35 120 0 1 {name=M4
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
C {sky130_fd_pr/nfet_01v8.sym} -37.5 55 0 1 {name=M5
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
C {lab_wire.sym} 232.5 -105 0 0 {name=p1 sig_type=std_logic lab=VDD}
C {gnd.sym} 133.75 163.75 0 0 {name=l1 lab=0}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 186.25 -62.5 0 1 {name=M3
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
model=pfet_01v8_hvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_hvt.sym} 36.25 -10 0 1 {name=M6
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
model=pfet_01v8_hvt
spiceprefix=X
}
