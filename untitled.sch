v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 570 -40 570 -20 {lab=0}
N 270 -60 270 -50 {lab=0}
N 270 -60 270 10 {lab=0}
N 480 -60 480 10 {lab=0}
N 480 -90 500 -90 {lab=#net1}
N 500 -140 500 -90 {lab=#net1}
N 480 -170 500 -170 {lab=#net1}
N 480 -140 480 -120 {lab=#net1}
N 270 -140 270 -120 {lab=#net1}
N 270 -170 480 -170 {lab=#net1}
N 270 -90 290 -90 {lab=#net1}
N 290 -140 290 -90 {lab=#net1}
N 570 -140 570 -100 {lab=#net1}
N 500 -170 570 -170 {lab=#net1}
N 380 -170 380 -160 {lab=#net1}
N 380 -100 380 -90 {lab=#net2}
N 380 -90 440 -90 {lab=#net2}
N 480 -170 480 -140 {lab=#net1}
N 500 -170 500 -140 {lab=#net1}
N 570 -170 570 -140 {lab=#net1}
N 290 -170 290 -140 {lab=#net1}
N 270 -170 270 -140 {lab=#net1}
N 170 -170 170 -160 {lab=#net1}
N 170 -170 270 -170 {lab=#net1}
N 170 -100 170 -90 {lab=#net3}
N 170 -90 230 -90 {lab=#net3}
C {devices/code.sym} -40 -70 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {vsource.sym} 170 -130 0 0 {name=V1 value=\{vsgpvt\} savecurrent=false}
C {gnd.sym} 570 -20 0 0 {name=l4 lab=0}
C {vsource.sym} 570 -70 0 0 {name=V2 value=1.8 savecurrent=false}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 250 -90 0 0 {name=M10
L=0.35
W=1
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 460 -90 0 0 {name=M11
L=0.15
W=1
nf=1 mult=1
model=pfet_01v8
spiceprefix=X
}
C {vsource.sym} 380 -130 0 0 {name=V3 value=\{vsgp\} savecurrent=false}
C {gnd.sym} 270 10 0 0 {name=l3 lab=0}
C {gnd.sym} 480 10 0 0 {name=l5 lab=0}
C {code_shown.sym} 680 -260 0 0 {name=s1 
only_toplevel=false 
value="
.param vsgpvt = 1
.param vsgp = 1

.control
.op
.endc

"
}
C {sky130_fd_pr/corner.sym} -20 100 0 0 {name=CORNER only_toplevel=true corner=tt}
