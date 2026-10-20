v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -250 -30 -250 -10 {lab=0}
N -50 100 -50 120 {lab=0}
N -50 10 -50 40 {lab=vref}
N -150 150 -150 170 {lab=0}
N -150 -30 -150 0 {lab=vi}
N -150 -40 -0 -40 {lab=vi}
N -150 -40 -150 -30 {lab=vi}
N -50 0 -50 10 {lab=vref}
N -50 -0 -0 0 {lab=vref}
N 70 30 70 60 {lab=0}
N 70 -120 70 -70 {lab=VDD}
N -250 -110 -250 -90 {lab=VDD}
N 590 50 590 80 {lab=#net1}
N 590 -40 590 -10 {lab=vo}
N -250 -120 -250 -110 {lab=VDD}
N -250 -120 70 -120 {lab=VDD}
N 680 50 680 80 {lab=0}
N 590 -40 680 -40 {lab=vo}
N 680 -40 680 -10 {lab=vo}
N 530 -40 590 -40 {lab=vo}
N 490 -40 490 -30 {lab=vo}
N 490 70 500 70 {lab=#net1}
N 590 140 590 160 {lab=0}
N 500 70 590 70 {lab=#net1}
N 260 -40 290 -40 {lab=#net2}
N 350 -40 400 -40 {lab=vo}
N 400 -40 400 -20 {lab=vo}
N 160 40 160 80 {lab=0}
N 400 40 400 80 {lab=0}
N 490 -40 530 -40 {lab=vo}
N 400 -40 490 -40 {lab=vo}
N 490 -30 490 10 {lab=vo}
N -150 60 -150 90 {lab=vii}
N 160 -40 160 -20 {lab=voo}
N 160 -40 200 -40 {lab=voo}
N 130 -40 160 -40 {lab=voo}
C {vsource.sym} -250 -60 0 0 {name=Vsuply value="dc \{VDD\} ac \{ac_vdd\}" savecurrent=false}
C {gnd.sym} -250 -10 0 0 {name=l2 lab=0}
C {vsource.sym} -50 70 0 0 {name=Vref value="\{VREF\}" savecurrent=false}
C {gnd.sym} -50 120 0 0 {name=l1 lab=0}
C {gnd.sym} 70 60 0 0 {name=l3 lab=0}
C {vsource.sym} -150 120 0 0 {name=Vin value=\{VIN\} savecurrent=false}
C {gnd.sym} -150 170 0 0 {name=l4 lab=0}
C {res.sym} 590 20 0 0 {name=R1
value=\{RL\}
footprint=1206
device=resistor
m=1}
C {gnd.sym} 590 160 0 0 {name=l5 lab=0}
C {capa-2.sym} 680 20 0 0 {name=C1
m=1
value=\{CL\}
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 680 80 0 0 {name=l6 lab=0}
C {lab_wire.sym} -50 -40 0 0 {name=p1 sig_type=std_logic lab=vi}
C {lab_wire.sym} 640 -40 0 0 {name=p2 sig_type=std_logic lab=vo}
C {lab_wire.sym} -50 0 0 0 {name=p3 sig_type=std_logic lab=vref}
C {isource.sym} 490 40 0 1 {name=Iload value="dc 0 ac 0 PULSE(\{iload_min\} \{iload_max\} \{tstart\} \{trise\} \{tfall\} \{twidth\} \{tperiod\})" savecurrent=true}
C {vsource.sym} 590 110 0 0 {name=Vsense value=0 savecurrent=false}
C {lab_wire.sym} -50 -120 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {vsource.sym} -150 30 2 0 {name=Vin1 value="dc 0 ac 0 " savecurrent=false}
C {/foss/designs/LDO-sky130/xschem/LDO_Top/LDO.sym} 150 -20 0 0 {name=x1}
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
C {code_shown.sym} -820 -560 0 0 {name=s2 only_toplevel=false value="





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
C {capa-2.sym} 160 10 0 0 {name=C2
m=1
value=2p
footprint=1206
device=polarized_capacitor}
C {res.sym} 230 -40 1 0 {name=R2
value=100m
footprint=1206
device=resistor
m=1}
C {ind.sym} 320 -40 1 0 {name=L7
m=1
value=5n
footprint=1206
device=inductor}
C {capa-2.sym} 400 10 0 0 {name=C3
m=1
value=1p
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 160 80 0 0 {name=l8 lab=0}
C {gnd.sym} 400 80 0 0 {name=l9 lab=0}
C {lab_wire.sym} 180 -40 0 0 {name=p5 sig_type=std_logic lab=voo}
C {lab_wire.sym} -150 80 0 0 {name=p6 sig_type=std_logic lab=vii}
C {vsource.sym} 150 180 1 0 {name=V1 value="0 ac \{ac_iprobe\}" savecurrent=false}
