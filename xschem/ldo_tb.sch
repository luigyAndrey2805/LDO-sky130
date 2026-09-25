v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -250 -30 -250 -10 {lab=0}
N -50 100 -50 120 {lab=0}
N -50 10 -50 40 {lab=#net1}
N -150 60 -150 80 {lab=0}
N -150 -30 -150 0 {lab=#net2}
N -150 -40 -0 -40 {lab=#net2}
N -150 -40 -150 -30 {lab=#net2}
N -50 0 -50 10 {lab=#net1}
N -50 -0 -0 0 {lab=#net1}
N 70 30 70 60 {lab=0}
N 70 -120 70 -70 {lab=#net3}
N -250 -110 -250 -90 {lab=#net3}
N 200 50 200 80 {lab=0}
N 200 -40 200 -10 {lab=#net4}
N 130 -40 200 -40 {lab=#net4}
N -250 -120 -250 -110 {lab=#net3}
N -250 -120 70 -120 {lab=#net3}
N 290 50 290 80 {lab=0}
N 290 -40 290 -10 {lab=#net4}
N 200 -40 290 -40 {lab=#net4}
C {/foss/designs/LDO-sky130/xschem/LDO.sym} 150 -20 0 0 {name=x1}
C {vsource.sym} -250 -60 0 0 {name=V1 value=\{VDD\} savecurrent=false}
C {gnd.sym} -250 -10 0 0 {name=l2 lab=0}
C {vsource.sym} -50 70 0 0 {name=V2 value=\{VREF\} savecurrent=false}
C {gnd.sym} -50 120 0 0 {name=l1 lab=0}
C {gnd.sym} 70 60 0 0 {name=l3 lab=0}
C {vsource.sym} -150 30 0 0 {name=V3 value=\{VIN\} savecurrent=false}
C {gnd.sym} -150 80 0 0 {name=l4 lab=0}
C {res.sym} 200 20 0 0 {name=R1
value=\{RL\}
footprint=1206
device=resistor
m=1}
C {gnd.sym} 200 80 0 0 {name=l5 lab=0}
C {capa-2.sym} 290 20 0 0 {name=C1
m=1
value=1p
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 290 80 0 0 {name=l6 lab=0}
