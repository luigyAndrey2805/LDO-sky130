v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 90 30 90 100 {lab=0}
N -30 10 -30 60 {lab=0}
N -30 60 90 60 {lab=0}
N -30 -90 -30 -50 {lab=VDD}
N -30 -90 90 -90 {lab=VDD}
N 90 -90 90 -70 {lab=VDD}
N 10 -20 40 -20 {lab=VR}
C {gnd.sym} 90 100 0 0 {name=l1 lab=0}
C {vsource.sym} -30 -20 0 1 {name=V1 value="dc \{VDD\} ac 0 PWL(0 0 10m 0 10.1m \{VDD\} 50m \{VDD\} 50.1m 0 100m 0 101m \{VDD\} 150m \{VDD\} 150.1m 0 200m 0 300m \{VDD\} 400m \{VDD\} 400.1m 0)"}
C {lab_wire.sym} 40 -90 0 0 {name=p1 sig_type=std_logic lab=VDD
}
C {lab_wire.sym} 10 -20 0 0 {name=p2 sig_type=std_logic lab=VR}
C {code_shown.sym} 300 -210 0 0 {name=s1
only_topleveL=false 
value="
* ==============================================================================
* Encabezado del bloque de simulación: s1 (self_bias_tb_pex.sch)
* Descripción:
*   Testbench post-layout (PEX) para el generador de corriente auto-polarizado
*   (self_bias). Incluye 'self_bias_pex.spice', configura condiciones iniciales
*   (.nodeset) para garantizar la convergencia en .OP, mapea los transistores
*   planos extraídos por Magic (X0..X35) y restringe los vectores guardados en
*   el transitorio largo (400.1 ms) para evitar desbordamiento de memoria RAM.
* ==============================================================================

* 1. Inclusión de librería de modelos Sky130 PRIMERO y luego el netlist PEX
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.include /foss/designs/LDO-sky130/xschem/Self_Bias/self_bias_pex.spice

.option temp=27
.option num_threads=8
.option gmin=1e-12 reltol=1e-3 abstol=1e-12 vntol=1e-6 itl1=500 itl2=200 itl4=100

**parametros_ldo
.param VDD = 1.8

.param tstart   = 10u
.param trise    = 200u
.param tfall    = 200u
.param tsim = 'tstart+2*trise+tfall'

* Condiciones de partida en los nodos reales de self_bias_pex.spice para que
* el análisis .OP converja sin error 'Timestep too small'
.nodeset V(VR)=0.6
.nodeset V(x1.vgp_self)=1.0
.nodeset V(x1.vdi)=0.6
.nodeset V(x1.vdinv)=0.0

* Guardar por defecto únicamente las señales clave para no desbordar la RAM
* durante los 200,050 puntos del análisis transitorio (400.1 ms / 2 us)
.save v(vdd) v(vr) v(x1.vgp_self) v(x1.vdi) v(x1.vdinv) i(V1)

.control
let tstart   = 10u
let trise    = 200u
let tfall    = 200u
let tsim = '$&tstart+4*$&trise+3*$&tfall'

* --- 1. Guardar nodos y parámetros de transistores reales del PEX para .OP ---
save v(vdd) v(vr) v(x1.vgp_self) v(x1.vdi) v(x1.vdinv) i(V1)

* Mp3 (pfet_01v8_lvt rama vdi, dedo representativo X0)
save @m.x1.x0.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.x0.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.x0.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x0.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.x0.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.x0.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.x0.msky130_fd_pr__pfet_01v8_lvt[vdsat]

* Mp4 (pfet_01v8_lvt rama vgp_self, dedo X2 + los 6 dedos para corriente total)
save @m.x1.x2.msky130_fd_pr__pfet_01v8_lvt[gm]
save @m.x1.x2.msky130_fd_pr__pfet_01v8_lvt[gds]
save @m.x1.x2.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x2.msky130_fd_pr__pfet_01v8_lvt[vgs]
save @m.x1.x2.msky130_fd_pr__pfet_01v8_lvt[vds]
save @m.x1.x2.msky130_fd_pr__pfet_01v8_lvt[vth]
save @m.x1.x2.msky130_fd_pr__pfet_01v8_lvt[vdsat]
save @m.x1.x7.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x11.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x14.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x16.msky130_fd_pr__pfet_01v8_lvt[id]
save @m.x1.x19.msky130_fd_pr__pfet_01v8_lvt[id]

* Ms1 (nfet_01v8 de arranque, dedo representativo X13)
save @m.x1.x13.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.x13.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.x13.msky130_fd_pr__nfet_01v8[id]
save @m.x1.x13.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.x13.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.x13.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.x13.msky130_fd_pr__nfet_01v8[vdsat]

* Ms3 (nfet_01v8 de arranque, dedo representativo X6)
save @m.x1.x6.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.x6.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.x6.msky130_fd_pr__nfet_01v8[id]
save @m.x1.x6.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.x6.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.x6.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.x6.msky130_fd_pr__nfet_01v8[vdsat]

* Mn1 (nfet_01v8 espejo inferior, dedo representativo X23)
save @m.x1.x23.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.x23.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.x23.msky130_fd_pr__nfet_01v8[id]
save @m.x1.x23.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.x23.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.x23.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.x23.msky130_fd_pr__nfet_01v8[vdsat]

* Mn2 (nfet_01v8 conectado a R_iref, dedo representativo X1)
save @m.x1.x1.msky130_fd_pr__nfet_01v8[gm]
save @m.x1.x1.msky130_fd_pr__nfet_01v8[gds]
save @m.x1.x1.msky130_fd_pr__nfet_01v8[id]
save @m.x1.x1.msky130_fd_pr__nfet_01v8[vgs]
save @m.x1.x1.msky130_fd_pr__nfet_01v8[vds]
save @m.x1.x1.msky130_fd_pr__nfet_01v8[vth]
save @m.x1.x1.msky130_fd_pr__nfet_01v8[vdsat]

set filetype=ascii
op
write self_bias_pex_tb.raw

* 2. Calcular VR e Ibias total (suma de los 6 dedos de Mp4 en microamperios)
let vr_op = v(vr)
let ibias_val_uA_op = (@m.x1.x2.msky130_fd_pr__pfet_01v8_lvt[id] + @m.x1.x7.msky130_fd_pr__pfet_01v8_lvt[id] + @m.x1.x11.msky130_fd_pr__pfet_01v8_lvt[id] + @m.x1.x14.msky130_fd_pr__pfet_01v8_lvt[id] + @m.x1.x16.msky130_fd_pr__pfet_01v8_lvt[id] + @m.x1.x19.msky130_fd_pr__pfet_01v8_lvt[id]) * 1e6

echo VR = $&vr_op
echo ibias = $&ibias_val_uA_op uA

* 3. Reiniciar y guardar SOLO los nodos principales antes del transitorio largo
reset
save v(vdd) v(vr) v(x1.vgp_self) v(x1.vdi) v(x1.vdinv) i(V1)

tran 2u 400.1m

* --- 4. Mediciones del Start-up ---
* Para Trise = 100us (Pulso activo entre 10m y 50m)
meas tran vr_100us FIND v(vr) at=40m

* Para Trise = 1ms (Pulso activo entre 100m y 150m)
meas tran vr_1ms FIND v(vr) at=140m

* Para Trise = 100ms (Pulso activo entre 200m y 400m)
meas tran vr_100ms FIND v(vr) at=390m

print vr_100us vr_1ms vr_100ms

.endc

"
}
C {/foss/designs/LDO-sky130/xschem/Self_Bias/self_bias.sym} -10 -20 0 0 {name=x1 schematic=ignore}
