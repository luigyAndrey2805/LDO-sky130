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
N 140 -110 140 -0 {lab=vin}
N 400 -140 400 -0 {lab=vo}
N 340 -140 400 -140 {lab=vo}
N 140 90 140 110 {lab=0}
N 140 0 140 30 {lab=vin}
N 140 -0 250 -0 {lab=vin}
N 310 -0 400 0 {lab=vo}
N 50 -90 50 -70 {lab=#net1}
N 50 -170 50 -150 {lab=vip}
N 50 -170 80 -170 {lab=vip}
N 400 90 400 110 {lab=0}
N 400 0 400 30 {lab=vo}
N 280 -320 320 -320 {lab=vdd}
C {/foss/designs/LDO-sky130/xschem/OTA.sym} 250 -140 0 0 {name=x1}
C {vsource.sym} 320 -260 0 0 {name=V1 value=\{VDD\} savecurrent=false}
C {gnd.sym} 260 -70 0 0 {name=l1 lab=0}
C {gnd.sym} 320 -210 0 0 {name=l2 lab=0}
C {gnd.sym} 50 0 0 0 {name=l3 lab=0}
C {vsource.sym} 50 -40 0 0 {name=V2 value=\{VCM\} savecurrent=false}
C {vsource.sym} 50 -120 0 0 {name=V3 value="ac \{VAC\}" savecurrent=false}
C {capa-2.sym} 140 60 0 0 {name=C1
m=1
value=1G
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 140 110 0 0 {name=l5 lab=0}
C {code_shown.sym} 540 -290 0 0 {name=s1 
only_topleveL=false 
value="


* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt

**parametros_ota
.param VDD = 1.8
.param VCM = 0.6
.param VAC = 1



.control

save all
* PMOS
* --- Circuito de Polarización (Referencia) ---

* Mr1 (pfet_01v8_lvt)
save @m.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[vdsat]

* Mr (pfet_01v8_lvt)
save @m.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vdsat]

* Mp2 (nfet_01v8)
save @m.x1.xMp2.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMp2.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMp2.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMp2.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMp2.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMp2.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMp2.msky130_fd_pr__nfet_01v8[vdsat]

* Mc3 (nfet_01v8)
save @m.x1.xMc3.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMc3.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMc3.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMc3.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMc3.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMc3.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMc3.msky130_fd_pr__nfet_01v8[vdsat]


* --- Etapa Diferencial (Núcleo del OTA) ---

* Mrc1 (pfet_01v8_lvt)
save @m.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[vdsat]

* Mn (pfet_01v8)
save @m.x1.xMn.msky130_fd_pr__pfet_01v8[gm]
save @m.x1.xMn.msky130_fd_pr__pfet_01v8[gds]
save @m.x1.xMn.msky130_fd_pr__pfet_01v8[id]
save @m.x1.xMn.msky130_fd_pr__pfet_01v8[vgs]
save @m.x1.xMn.msky130_fd_pr__pfet_01v8[vds]
save @m.x1.xMn.msky130_fd_pr__pfet_01v8[vth]
save @m.x1.xMn.msky130_fd_pr__pfet_01v8[vdsat]

* Mp (pfet_01v8)
save @m.x1.xMp.msky130_fd_pr__pfet_01v8[gm]
save @m.x1.xMp.msky130_fd_pr__pfet_01v8[gds]
save @m.x1.xMp.msky130_fd_pr__pfet_01v8[id]
save @m.x1.xMp.msky130_fd_pr__pfet_01v8[vgs]
save @m.x1.xMp.msky130_fd_pr__pfet_01v8[vds]
save @m.x1.xMp.msky130_fd_pr__pfet_01v8[vth]
save @m.x1.xMp.msky130_fd_pr__pfet_01v8[vdsat]

* Mnr (nfet_01v8)
save @m.x1.xMnr.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMnr.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMnr.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMnr.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMnr.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMnr.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMnr.msky130_fd_pr__nfet_01v8[vdsat]

* Mpr (nfet_01v8)
save @m.x1.xMpr.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMpr.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMpr.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMpr.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMpr.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMpr.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMpr.msky130_fd_pr__nfet_01v8[vdsat]


* --- Etapa de Salida ---

* Mrc2 (pfet_01v8_lvt)
save @m.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[vdsat]

* Mo (nfet_01v8)
save @m.x1.xMo.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMo.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMo.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMo.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMo.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMo.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMo.msky130_fd_pr__nfet_01v8[vdsat]

set filetype=ascii
op
write OTA_op.raw


ac dec 10 1 1G
write OTA_ac.raw


* 1. Frecuencia de Corte a -3dB
meas ac f3db WHEN vdb(vo) = vdb(vo)[0] - 3

* 2. UGB (Frecuencia donde la magnitud cruza 0 dB)
meas ac ugb WHEN vdb(vo) = 0

* 3. Crear el vector de fase y convertirlo a grados (multiplicando por 180/pi)
let fase_deg = cph(v(vo)) * 180 / pi

* 4. Medir la fase en grados en el punto exacto del UGB
meas ac fase_ugb FIND fase_deg WHEN vdb(vo) = 0

* 5. Calcular el Margen de Fase automáticamente
let margen_fase = 180 + fase_ugb
print margen_fase

* 6. Graficar la magnitud y la fase ya convertida a grados
plot vdb(vo)
plot fase_deg
.endc
"
}
C {lab_wire.sym} 110 -170 0 0 {name=p1 sig_type=std_logic lab=vip}
C {lab_wire.sym} 170 -110 0 0 {name=p2 sig_type=std_logic lab=vin}
C {lab_wire.sym} 400 -90 0 0 {name=p3 sig_type=std_logic lab=vo}
C {ind.sym} 280 0 3 0 {name=L4
m=1
value=1G
footprint=1206
device=inductor}
C {capa-2.sym} 400 60 0 0 {name=C2
m=1
value=10e-12
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 400 110 0 0 {name=l6 lab=0}
C {lab_wire.sym} 300 -320 0 0 {name=p4 sig_type=std_logic lab=vdd}
