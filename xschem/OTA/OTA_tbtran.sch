v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 260 -90 260 -70 {lab=0}
N 320 -230 320 -210 {lab=0}
N 320 -320 320 -290 {lab=vdd}
N 260 -210 260 -190 {lab=vdd}
N 260 -210 280 -210 {lab=vdd}
N 280 -320 280 -210 {lab=vdd}
N 50 -10 50 0 {lab=0}
N 80 -170 190 -170 {lab=vip}
N 140 -110 190 -110 {lab=vin}
N 400 -140 400 -0 {lab=vo}
N 340 -140 400 -140 {lab=vo}
N 50 -90 50 -70 {lab=vin}
N 50 -170 50 -150 {lab=vip}
N 50 -170 80 -170 {lab=vip}
N 50 -80 140 -80 {lab=vin}
N 140 -110 140 -80 {lab=vin}
N 280 -320 320 -320 {lab=vdd}
N 300 -110 300 -60 {lab=#net1}
N 240 -10 250 -10 {lab=0}
N 240 -80 240 -10 {lab=0}
N 240 -80 260 -80 {lab=0}
N 350 -10 370 -10 {lab=vdd}
C {/foss/designs/LDO-sky130/xschem/OTA/OTA.sym} 250 -140 0 0 {name=x1  lvs_ignore=true}
C {vsource.sym} 320 -260 0 0 {name=V1 value=\{VDD\} savecurrent=false}
C {gnd.sym} 260 -70 0 0 {name=l1 lab=0}
C {gnd.sym} 320 -210 0 0 {name=l2 lab=0}
C {gnd.sym} 50 0 0 0 {name=l3 lab=0}
C {vsource.sym} 50 -40 0 0 {name=V2 value=\{VCM\} savecurrent=false}
C {vsource.sym} 50 -120 0 0 {name=V3 value="PWL(0 \{-deltavin\} \{tsim\} \{deltavin\})"  savecurrent=false}
C {code_shown.sym} 540 -300 0 0 {name=s1 
only_topleveL=false 
value="


* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.include /foss/designs/LDO-sky130/xschem/OTA/OTA_pex.spice

**parametros_ota
.param VDD = 1.8
.param VCM = 0.6
.param VAC = 1
.param deltavin = 50m
.param tsim = 2m

* === SOLUCIÓN: Definir el análisis transitorio AQUÍ AFUERA ===
.tran 1u \{tsim\}

.control
save all

* 1. Ejecutar y guardar Punto de Operación
op
write OTA_op.raw all

* 2. Ejecutar el análisis transitorio definido arriba
run

* 3. Graficar resultados
plot v(vo)
plot v(vip)

* 4. Guardar datos transitorios
write OTA_trans.raw all
.endc

"
}
C {lab_wire.sym} 110 -170 0 0 {name=p1 sig_type=std_logic lab=vip}
C {lab_wire.sym} 170 -110 0 0 {name=p2 sig_type=std_logic lab=vin}
C {lab_wire.sym} 400 -90 0 0 {name=p3 sig_type=std_logic lab=vo}
C {lab_wire.sym} 280 -250 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 370 -10 0 0 {name=p5 sig_type=std_logic lab=vdd}
C {/foss/designs/LDO-sky130/xschem/Self_Bias/self_bias.sym} 300 -110 1 0 {name=x2}
