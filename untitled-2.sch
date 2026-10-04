v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
L 4 830 -1270 850 -1270 {}
L 4 700 -1240 720 -1240 {}
L 4 700 -1300 720 -1300 {}
L 4 720 -1330 720 -1210 {}
L 4 720 -1210 830 -1270 {}
L 4 720 -1330 830 -1270 {}
L 4 740 -1310 740 -1290 {}
L 4 730 -1240 750 -1240 {}
L 4 730 -1300 750 -1300 {}
L 7 770 -1320 770 -1300 {}
L 7 740 -1340 740 -1320 {}
L 7 770 -1240 770 -1220 {}
B 5 767.5 -1322.5 772.5 -1317.5 {name=VDD dir=inout}
B 5 847.5 -1272.5 852.5 -1267.5 {name=VO_ota dir=out}
B 5 697.5 -1242.5 702.5 -1237.5 {name=VIN_ota dir=in}
B 5 697.5 -1302.5 702.5 -1297.5 {name=VIP_ota dir=in}
B 5 737.5 -1342.5 742.5 -1337.5 {name=Iref dir=inout}
B 5 767.5 -1222.5 772.5 -1217.5 {name=VSS dir=inout}
T {@symname} 728.5 -1276 0 0 0.3 0.3 {}
T {@name} 895 -1322 0 0 0.2 0.2 {}
T {VDD} 805 -1314 0 1 0.2 0.2 {}
T {VO_ota} 855 -1294 0 1 0.2 0.2 {}
T {VIN_ota} 665 -1234 0 0 0.2 0.2 {}
T {VIP_ota} 675 -1324 0 0 0.2 0.2 {}
T {Iref} 735 -1344 0 1 0.2 0.2 {}
T {VSS} 785 -1226 2 1 0.2 0.2 {}
C {sky130_fd_pr/res_iso_pw.sym} -70 -40 0 0 {name=Rs
W=0.35
L=0.44
model=res_iso_pw
spiceprefix=X
mult=1}
C {res.sym} 150 -40 0 0 {name=Rs1
value=\{rs\}
footprint=1206
device=resistor
m=1}
C {sky130_fd_pr/res_iso_pw.sym} -210 0 0 0 {name=R3
W=0.7
L=0.4
model=res_iso_pw
spiceprefix=X
mult=1}
C {code_shown.sym} -1940 -1920 0 0 {name=s1 
only_topleveL=false 
value="


* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.option temp=125
.option num_threads=8

**parametros_ldo
.param VDD = 1.8
.param VREF = 0.6
.param VIN = '1*VDD'
.param RL = 1e6
.param CL = 1u
.param tsim = 2m
* Parámetros para la prueba de carga del LDO
.param iload_min = 1m
.param iload_max = 50m
.param tstart   = 10u
.param trise    = 100n
.param tfall    = 100n
.param twidth   = 100u
.param tperiod  = 200u

.param tsim = '3*tperiod'

.param ac_iprobe = 1
.param ac_vdd = 0 




.control
let tperiod  = 200u
let tsim = '3*tperiod'


* 2. Análisis Transitorio para overshot y undershot (.TRAN)
tran 1u $&tsim
write LDO_tran_picos.raw

* 3. Análisis en Frecuencia  para estabilidad (.AC)
ac dec 10 10 1G
* 1. Ganancia de Lazo Abierto T(s) = v(x1.vre) / v(x1.net3)
let T_loop = v(x1.vre) / v(x1.net3)
let loop_gain_db = vdb(T_loop)
let fase_deg = vp(T_loop) * 180 / pi
write LDO_ac_estability.raw


* 5. Analisis en dc sweep para el line regulation 
dc vin 1.3 2 0.05
*plot vo
*plot vi
write LDO_dc_line.raw

*6. análisis en Frecuencia (.AC) para el PSRR
alterparam ac_iprobe = 0
alterparam ac_vdd = 1
reset 
ac dec 10 10 1G
* 1. Ganancia de Lazo Abierto T(s) = v(x1.vre) / v(x1.net3)
let psrr1 = v(vdd)/v(vo) 
let psrr_db = vdb(psrr1)
write LDO_ac_psrr.raw

* 4. Análisis en dc sweep para el load regulation
alterparam RL = 1e9
reset
dc iload 400u 50m 200u
*plot vo
*plot vsense#branch
write LDO_dc_load.raw


* ANALISIS EN DC PARA EL DROPOUT
alterparam RL = 24
reset 
dc vin1 0 2 0.05
write LDO_dc_dropout.raw




*CALCULOS PARA ESTABILIDAD Y GANANCIA EN LAZO ABIERTO 

setplot ac1
* 2. UGB (Frecuencia donde la magnitud cruza 0 dB)
meas ac ugb WHEN loop_gain_db = 0.0
* 3. Medir la fase en grados en el punto exacto del UGB
meas ac fase_ugb FIND fase_deg WHEN loop_gain_db = 0.0

* 4. Calcular el Margen de Fase (PM = fase_ugb)
let margen_fase = fase_ugb
meas ac ganancia_banda_plana   find loop_gain_db at=1
echo 'margen_fase = $&fase_ugb'

*CALCULOS PARA EL PSRR
setplot ac2
meas ac gananciaPSRR_1   find psrr_db at=1
meas ac gananciaPSRR_1k  find psrr_db at=1k
meas ac gananciaPSRR_10k find psrr_db at=10k
meas ac gananciaPSRR_1M  find psrr_db at=1Meg

*CALCULOS PARA EL LOAD REGULATION         
setplot dc1
meas dc voload_max MAX v(vo)
meas dc voload_min MIN v(vo)
let load_regulation = voload_max - voload_min
echo 'load_regulation = $&load_regulation'

*CALCULOS PARA EL LINE REGULATION 
setplot dc2
meas dc voline_max MAX v(vo)
meas dc voline_min MIN v(vo)
let line_regulation = voline_max - voline_min
echo 'line_regulation = $&line_regulation'

*CALCULOS PARA EL DROPOUT
setplot dc3

* 1. Usamos v(vo) para el nodo y v-sweep para el eje X (que es el barrido de 'vin')
meas dc vout_nom FIND v(vo) WHEN vi = 1.55

* 2. Calcular dinámicamente el valor objetivo al 99.5% (0.5% de caída según tu código)
let vout_target = vout_nom * 0.995

* 3. Encontrar el Vin en el que Vout cruza el vout_target (usamos cross=1 en lugar de fall=1)
meas dc vin_do FIND vi WHEN vo = vout_target fall=1

* 4. Calcular el Dropout exacto (cambiado *e3 por *1e3)
let dropout_mV = (vin_do - vout_target) * 1e3

* 5. Imprimir las variables con los nombres correctos
print vout_nom vout_target vin_do dropout_mV

*CALCULOS PARA OVERSHOOT E UNDERSHOOT
*CALCULOS PARA OVERSHOOT E UNDERSHOOT
setplot tran1

* 1. Medir el voltaje estable en carga ligera (justo antes de tstart = 10u)
meas tran v_estable_ligera FIND v(vo) AT=9u

* 2. Medir el voltaje estable en carga pesada (justo antes de que acabe el pulso en 210u)
meas tran v_estable_pesada FIND v(vo) AT=20u

* 3. Encontrar los picos absolutos de la simulación
meas tran vo_max MAX v(vo)
meas tran vo_min MIN v(vo)

* 4. Calcular el Undershoot y Overshoot verdaderos (en milivoltios)
* Undershoot: Lo que cae respecto al valor que tenía en carga ligera
let undershoot_mV = (v_estable_ligera - vo_min) * 1e3

* Overshoot: Lo que sube respecto al valor que tenía en carga pesada
let overshoot_mV = (vo_max - v_estable_pesada) * 1e3

* 5. Imprimir resultados en la consola
echo '--- RESULTADOS DE TRANSIENTE ---'
print undershoot_mV overshoot_mV v_estable_ligera v_estable_pesada
.endc

"
}
C {code_shown.sym} -2710 -1130 0 0 {name=s2 
only_topleveL=false 
value="




.control



* 1. Punto de Operación (.OP)

* --- Circuito de Polarización (Referencia) ---
save all


save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[vdsat]


* Mr1 (pfet_01v8_lvt)
save @m.x1.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.x1.xMr1.msky130_fd_pr__pfet_01v8_lvt[vdsat]

* Mr (pfet_01v8_lvt)
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vdsat]

* Mp2 (nfet_01v8)
save @m.x1.x1.xMp2.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.x1.xMp2.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.x1.xMp2.msky130_fd_pr__nfet_01v8[id]
save @m.x1.x1.xMp2.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.x1.xMp2.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.x1.xMp2.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.x1.xMp2.msky130_fd_pr__nfet_01v8[vdsat]

* Mc3 (nfet_01v8)
save @m.x1.x1.xMc3.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.x1.xMc3.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.x1.xMc3.msky130_fd_pr__nfet_01v8[id]
save @m.x1.x1.xMc3.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.x1.xMc3.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.x1.xMc3.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.x1.xMc3.msky130_fd_pr__nfet_01v8[vdsat]


* --- Etapa Diferencial (Núcleo del OTA) ---

* Mrc1 (pfet_01v8_lvt)
save @m.x1.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.x1.xMrc1.msky130_fd_pr__pfet_01v8_lvt[vdsat]

* Mn (pfet_01v8)
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8[gm]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8[gds]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8[id]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8[vgs]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8[vds]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8[vth]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8[vdsat]

* Mp (pfet_01v8)
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8[gm]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8[gds]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8[id]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8[vgs]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8[vds]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8[vth]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8[vdsat]

* Mnr (nfet_01v8)
save @m.x1.x1.xMnr.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.x1.xMnr.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.x1.xMnr.msky130_fd_pr__nfet_01v8[id]
save @m.x1.x1.xMnr.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.x1.xMnr.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.x1.xMnr.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.x1.xMnr.msky130_fd_pr__nfet_01v8[vdsat]

* Mpr (nfet_01v8)
save @m.x1.x1.xMpr.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.x1.xMpr.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.x1.xMpr.msky130_fd_pr__nfet_01v8[id]
save @m.x1.x1.xMpr.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.x1.xMpr.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.x1.xMpr.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.x1.xMpr.msky130_fd_pr__nfet_01v8[vdsat]


* --- Etapa de Salida ---

* Mrc2 (pfet_01v8_lvt)
save @m.x1.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.x1.xMrc2.msky130_fd_pr__pfet_01v8_lvt[vdsat]

* Mo (nfet_01v8)
save @m.x1.x1.xMo.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.x1.xMo.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.x1.xMo.msky130_fd_pr__nfet_01v8[id]
save @m.x1.x1.xMo.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.x1.xMo.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.x1.xMo.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.x1.xMo.msky130_fd_pr__nfet_01v8[vdsat]


op
set filetype=ascii
write LDO_op.raw




.endc
"
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -240 -1340 3 0 {name=M1
W=1000
L=0.5
nf=200
mult=5
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -330 -1300 3 0 {name=M2
W=1000
L=0.5
nf=100
mult=5
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
