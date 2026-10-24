v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -550 -180 -550 -160 {lab=0}
N -30 190 -30 210 {lab=0}
N -30 100 -30 130 {lab=#net1}
N -490 80 -490 100 {lab=0}
N -490 -100 -490 -70 {lab=#net2}
N -490 -110 -340 -110 {lab=#net2}
N -490 -110 -490 -100 {lab=#net2}
N -30 -70 -30 -60 {lab=vref}
N -30 -70 20 -70 {lab=vref}
N 110 180 110 210 {lab=0}
N 90 -190 90 -140 {lab=VDD}
N -550 -260 -550 -240 {lab=#net3}
N 610 -20 610 10 {lab=#net4}
N 610 -110 610 -80 {lab=vo}
N -550 -270 -550 -260 {lab=#net3}
N -550 -270 -230 -270 {lab=#net3}
N 700 70 700 100 {lab=0}
N 610 -110 700 -110 {lab=vo}
N 700 -110 700 -80 {lab=vo}
N 550 -110 610 -110 {lab=vo}
N 510 -110 510 -100 {lab=vo}
N 510 0 520 0 {lab=#net4}
N 610 70 610 90 {lab=0}
N 520 0 610 0 {lab=#net4}
N 280 -110 310 -110 {lab=#net5}
N 370 -110 420 -110 {lab=vo}
N 420 -110 420 -90 {lab=vo}
N 180 -30 180 10 {lab=0}
N 420 -30 420 10 {lab=0}
N 510 -110 550 -110 {lab=vo}
N 420 -110 510 -110 {lab=vo}
N 510 -100 510 -60 {lab=vo}
N -490 -10 -490 20 {lab=vii}
N 180 -110 180 -90 {lab=voo}
N 180 -110 220 -110 {lab=voo}
N 150 -110 180 -110 {lab=voo}
N -340 -50 -340 -30 {lab=0}
N -120 -50 -120 -30 {lab=0}
N -160 -110 -120 -110 {lab=vi}
N -250 -110 -220 -110 {lab=#net6}
N -340 -110 -310 -110 {lab=#net2}
N -120 -110 20 -110 {lab=vi}
N -30 10 -30 40 {lab=#net7}
N -30 -60 -30 -50 {lab=vref}
N 20 60 20 80 {lab=0}
N -100 190 -100 210 {lab=0}
N -100 120 -100 130 {lab=#net1}
N -100 120 -30 120 {lab=#net1}
N 20 -70 20 0 {lab=vref}
N 700 -10 700 10 {lab=#net8}
N -230 -210 -230 -190 {lab=0}
N -10 -210 -10 -190 {lab=0}
N -50 -270 -10 -270 {lab=VDD}
N -140 -270 -110 -270 {lab=#net9}
N -230 -270 -200 -270 {lab=#net3}
N -10 -270 90 -270 {lab=VDD}
N 90 -270 90 -190 {lab=VDD}
N 110 90 110 120 {lab=#net10}
N 110 10 110 30 {lab=#net11}
N 90 10 110 10 {lab=#net11}
N 90 -40 90 10 {lab=#net11}
N 700 -80 700 -70 {lab=vo}
C {code_shown.sym} 800 -570 0 0 {name=s1
only_topleveL=false 
value="







.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice ff_lh
.option temp=-40
.param VDD = 1.98

.option num_threads=8

.param rsh_var = agauss(0, 0.005, 1)


* Forzar un punto de partida para ayudar a la convergencia
.nodeset V(VO)=1.2
.nodeset V(x1.Vre)=0.6




**parametros_ldo

.param VREF = 0.6
.param VIN = '1*VDD-0.3'
.param RL = 1200
.param CL = 1u
.param tsim = 2m

* Parámetros para la prueba de carga del LDO
.param iload_min = 1u
.param iload_max = 5m
.param tstart   = 30u
.param trise    = 100n
.param tfall    = 100n
.param twidth   = 100u
.param tperiod  = 200u

.param tsim = '3*tperiod'

.param ac_iprobe = 1
.param ac_vdd = 0 

* --- Clamp SOLO de simulación (evita soluciones DC falsas de cientos de V) ---
* Diodo a tierra: conduce si vo baja de -0.2 V
Dclpn 0 vo dclamp_tb
* Diodo a una fuente de 5 V: conduce si vo sube de 5.7 V
Dclpp vo vclp dclamp_tb
* Fuente de referencia para el clamp superior
Dclpn2 0 x1.vre dclamp_tb
Dclpp2 x1.vre vclp dclamp_tb
Vclp vclp 0 5
* Modelo del diodo (fuga ~fA, sin capacitancia: no altera AC ni transitorio)
.model dclamp_tb D(IS=1e-15 N=1)









.control
let tperiod  = 200u
let tsim = '3*tperiod'


* =========================================================
* 2. AC (Estabilidad) -> Genera plot ac1
* =========================================================

ac dec 10 1 1G


let T_loop = v(x1.vre) / v(x1.vre2)
let ldb = vdb(T_loop)
let fase = vp(T_loop) * 180 / pi

write LDO_ac_estability.raw
meas ac ugb WHEN ldb = 0.0
meas ac fase_ugb FIND fase WHEN ldb = 0.0
let margen_fase = fase_ugb
meas ac ganancia_banda_plana find ldb at=1

* =========================================================
* 3. AC (PSRR) -> Genera plot ac2
* =========================================================
alterparam ac_iprobe = 0
alterparam ac_vdd = 1
reset 

ac dec 10 10 1G


let psrr1 = v(vdd)/v(vo) 
let psrr_db = vdb(psrr1)
write LDO_ac_psrr.raw
meas ac gananciaPSRR_1   find psrr_db at=10
meas ac gananciaPSRR_1k  find psrr_db at=1k
meas ac gananciaPSRR_10k find psrr_db at=10k
meas ac gananciaPSRR_1M  find psrr_db at=1Meg

* =========================================================
* 4. TRANSIENTE (Line Regulation) -> Genera plot tran1
* =========================================================
alterparam ac_iprobe = 0
alterparam ac_vdd = 0
reset

alter @Vin[pwl] = [ 0 1.4 1m 1.8 ]
alter @Iload[pwl] = [ 0 1u 1m 1u ]
    
tran 1u 1m 
write LDO_dc_line.raw

let t_line_ini = 40u
let t_line_fin = 950u

meas tran voline_max MAX v(vo) from=$&t_line_ini to=$&t_line_fin
meas tran voline_min MIN v(vo) from=$&t_line_ini to=$&t_line_fin
let line_regulation_mV = (voline_max - voline_min)*1000
meas tran salida_line avg v(vo) from=$&t_line_ini to=$&t_line_fin
* =========================================================

* 1. TRANSIENTE (Overshoot y Undershoot) -> Genera plot tran2
* =========================================================
alterparam ac_iprobe = 0
alterparam ac_vdd = 0
alterparam RL = 240e9
reset
    
tran 1u $&tsim 
write LDO_tran_picos.raw

let t_ignorar = 150u

meas tran v_estable_ligera FIND v(vo) AT=270u
meas tran v_estable_pesada FIND v(vo) AT=180u
meas tran vo_max MAX v(vo) from=$&t_ignorar to=$&tsim
meas tran vo_min MIN v(vo) from=$&t_ignorar to=$&tsim

let undershoot_mV = (v_estable_ligera - vo_min) * 1e3
let overshoot_mV = (vo_max - v_estable_pesada) * 1e3
meas tran salida_tran avg v(vo) from=$&t_ignorar to=$&tsim


* =========================================================
* 5. TRANSIENTE (Load Regulation) -> Genera plot tran3
* =========================================================
alterparam RL = 240e9
reset
alter @Iload[pwl] = [ 0 1u 1m 5m ]
    
tran 1u 1m 
write LDO_dc_load.raw

meas tran vout_light FIND v(vo) AT=40u
meas tran vout_heavy FIND v(vo) AT=1m
let load_regulation_mV = (vout_light - vout_heavy) * 1000

* =========================================================
* 6. TRANSIENTE (Dropout) -> Genera plot tran4
* =========================================================
alterparam RL = 240
reset 
alter @Vin[pwl] = [ 0 2 1m 0 ]
alter @Iload[pwl] = [ 0 1u 1m 1u ]

tran 1u 1m 
write LDO_dc_dropout.raw

meas tran vout_nom FIND v(vo) AT=225u
let vout_target = vout_nom * 0.90
meas tran vin_do FIND v(vi) WHEN v(vo) = vout_target fall=1
let dropout_mV = (vin_do - vout_target) * 1e3

* =========================================================
* IMPRESION DE TODOS LOS RESULTADOS CON SETPLOT
* =========================================================

echo '--- RESULTADOS DE TRANSIENTE ---'
setplot tran3
print undershoot_mV overshoot_mV v_estable_ligera v_estable_pesada salida_tran

echo '--- RESULTADOS AC (ESTABILIDAD) ---'
setplot ac1
print ugb fase_ugb margen_fase ganancia_banda_plana

echo '--- RESULTADOS AC (PSRR) ---'
setplot ac2
print gananciaPSRR_1 gananciaPSRR_1k gananciaPSRR_10k gananciaPSRR_1M

echo '--- RESULTADOS REGULACIONES Y DROPOUT ---'
echo '>> Line Regulation'
setplot tran2
print line_regulation_mV salida_line 

echo '>> Load Regulation'
setplot tran4
print load_regulation_mV

echo '>> Dropout'
setplot tran5
print dropout_mV vin_do vout_target

.endc













"
}
C {code_shown.sym} -2260 -750 0 0 {name=s2 only_toplevel=false value="





.control



alterparam RL = 1200
alterparam ac_iprobe = 0
alterparam ac_vdd = 0

reset

*  Punto de Operación (.OP)

save all


save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.xM1.msky130_fd_pr__pfet_01v8_lvt[vdsat]




save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.x1.xMr.msky130_fd_pr__pfet_01v8_lvt[vdsat]

save @m.x1.x1.xMnref.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.x1.xMnref.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.x1.xMnref.msky130_fd_pr__nfet_01v8[id]
save @m.x1.x1.xMnref.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.x1.xMnref.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.x1.xMnref.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.x1.xMnref.msky130_fd_pr__nfet_01v8[vdsat]

save @m.x1.xMnl.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.xMnl.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.xMnl.msky130_fd_pr__nfet_01v8[id]
save @m.x1.xMnl.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.xMnl.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.xMnl.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.xMnl.msky130_fd_pr__nfet_01v8[vdsat]



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
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.x1.xMn.msky130_fd_pr__pfet_01v8_lvt[vdsat]

* Mp (pfet_01v8)
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.x1.xMp.msky130_fd_pr__pfet_01v8_lvt[vdsat]

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




"}
C {vsource.sym} -550 -210 0 0 {name=Vsuply value="dc \{VDD\} ac \{ac_vdd\}" savecurrent=false}
C {gnd.sym} -550 -160 0 0 {name=l2 lab=0}
C {vsource.sym} -30 160 0 0 {name=Vref value="\{VREF\}" savecurrent=false}
C {gnd.sym} -30 210 0 0 {name=l1 lab=0}
C {gnd.sym} 110 210 0 0 {name=l3 lab=0}
C {vsource.sym} -490 50 0 0 {name=Vin value=\{VIN\} savecurrent=false}
C {gnd.sym} -490 100 0 0 {name=l4 lab=0}
C {res.sym} 610 -50 0 0 {name=R1
value=\{RL\}
footprint=1206
device=resistor
m=1}
C {gnd.sym} 610 90 0 0 {name=l5 lab=0}
C {capa-2.sym} 700 40 0 0 {name=C1
m=1
value=\{CL\}
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 700 100 0 0 {name=l6 lab=0}
C {lab_wire.sym} -40 -110 0 0 {name=p1 sig_type=std_logic lab=vi}
C {lab_wire.sym} 660 -110 0 0 {name=p2 sig_type=std_logic lab=vo}
C {lab_wire.sym} -30 -70 0 0 {name=p3 sig_type=std_logic lab=vref}
C {isource.sym} 510 -30 0 1 {name=Iload value="dc 0 ac 0 PULSE(\{iload_min\} \{iload_max\} \{tstart\} \{trise\} \{tfall\} \{twidth\} \{tperiod\})" savecurrent=true}
C {vsource.sym} 610 40 0 0 {name=Vsense value=0 savecurrent=false}
C {lab_wire.sym} 90 -160 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {vsource.sym} -490 -40 2 0 {name=Vin1 value="dc 0 ac 0 " savecurrent=false}
C {/foss/designs/LDO-sky130/xschem/LDO_Top/LDO.sym} 170 -90 0 0 {name=x1 }
C {capa-2.sym} 180 -60 0 0 {name=C2
m=1
value=2p
footprint=1206
device=polarized_capacitor}
C {res.sym} 250 -110 1 0 {name=R2
value=100m
footprint=1206
device=resistor
m=1}
C {ind.sym} 340 -110 1 0 {name=L7
m=1
value=5n
footprint=1206
device=inductor}
C {capa-2.sym} 420 -60 0 0 {name=C3
m=1
value=1.5p
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 180 10 0 0 {name=l8 lab=0}
C {gnd.sym} 420 10 0 0 {name=l9 lab=0}
C {lab_wire.sym} 200 -110 0 0 {name=p5 sig_type=std_logic lab=voo}
C {lab_wire.sym} -490 10 0 0 {name=p6 sig_type=std_logic lab=vii}
C {ind.sym} -190 -110 1 0 {name=L10
m=1
value=5n
footprint=1206
device=inductor}
C {capa-2.sym} -120 -80 0 0 {name=C4
m=1
value=2p
footprint=1206
device=polarized_capacitor}
C {capa-2.sym} -340 -80 0 0 {name=C5
m=1
value=1.5p
footprint=1206
device=polarized_capacitor}
C {res.sym} -280 -110 1 0 {name=R3
value=100m
footprint=1206
device=resistor
m=1}
C {gnd.sym} -120 -30 0 0 {name=l11 lab=0}
C {gnd.sym} -340 -30 0 0 {name=l12 lab=0}
C {ind.sym} -30 70 2 0 {name=L13
m=1
value=5n
footprint=1206
device=inductor}
C {res.sym} -30 -20 2 0 {name=R4
value=200m
footprint=1206
device=resistor
m=1}
C {capa-2.sym} 20 30 0 0 {name=C6
m=1
value=500f
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 20 80 0 0 {name=l14 lab=0}
C {capa-2.sym} -100 160 0 0 {name=C7
m=1
value=1.5p
footprint=1206
device=polarized_capacitor}
C {gnd.sym} -100 210 0 0 {name=l15 lab=0}
C {res.sym} 700 -40 2 0 {name=R5
value=20m
footprint=1206
device=resistor
m=1}
C {ind.sym} -80 -270 1 0 {name=L16
m=1
value=5n
footprint=1206
device=inductor}
C {capa-2.sym} -10 -240 0 0 {name=C8
m=1
value=10p
footprint=1206
device=polarized_capacitor}
C {capa-2.sym} -230 -240 0 0 {name=C9
m=1
value=1.5p
footprint=1206
device=polarized_capacitor}
C {res.sym} -170 -270 1 0 {name=R6
value=5m
footprint=1206
device=resistor
m=1}
C {gnd.sym} -10 -190 0 0 {name=l17 lab=0}
C {gnd.sym} -230 -190 0 0 {name=l18 lab=0}
C {ind.sym} 110 150 2 0 {name=L19
m=1
value=5n
footprint=1206
device=inductor}
C {res.sym} 110 60 2 0 {name=R7
value=5m
footprint=1206
device=resistor
m=1}
