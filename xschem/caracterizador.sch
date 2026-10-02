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
N 480 -90 500 -90 {lab=VDD}
N 500 -140 500 -90 {lab=VDD}
N 480 -170 500 -170 {lab=VDD}
N 480 -140 480 -120 {lab=VDD}
N 270 -140 270 -120 {lab=VDD}
N 270 -170 480 -170 {lab=VDD}
N 270 -90 290 -90 {lab=VDD}
N 290 -140 290 -90 {lab=VDD}
N 570 -140 570 -100 {lab=VDD}
N 500 -170 570 -170 {lab=VDD}
N 480 -170 480 -140 {lab=VDD}
N 500 -170 500 -140 {lab=VDD}
N 570 -170 570 -140 {lab=VDD}
N 290 -170 290 -140 {lab=VDD}
N 270 -170 270 -140 {lab=VDD}
N 170 -170 170 -160 {lab=VDD}
N 170 -170 270 -170 {lab=VDD}
N 170 -100 170 -90 {lab=vgp}
N 170 -90 230 -90 {lab=vgp}
N 410 -90 440 -90 {lab=vgp}
N 270 260 270 280 {lab=0}
N 160 260 270 260 {lab=0}
N 160 250 160 260 {lab=0}
N 480 200 480 280 {lab=0}
N 270 260 480 260 {lab=0}
N 270 200 270 260 {lab=0}
N 270 170 300 170 {lab=0}
N 300 170 300 260 {lab=0}
N 480 170 510 170 {lab=0}
N 510 170 510 260 {lab=0}
N 480 260 510 260 {lab=0}
N 160 170 160 190 {lab=vgn}
N 160 170 230 170 {lab=vgn}
N 270 110 270 140 {lab=VDD}
N 270 110 480 110 {lab=VDD}
N 480 110 480 140 {lab=VDD}
N 410 170 440 170 {lab=vgn}
C {vsource.sym} 170 -130 0 0 {name=Vgp value=\{vsg\} savecurrent=false}
C {gnd.sym} 570 -20 0 0 {name=l4 lab=0}
C {vsource.sym} 570 -70 0 0 {name=Vdd value=1.8 savecurrent=false}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 250 -90 0 0 {name=Mplvt
L=0.35
W=200
nf=10
mult=1
modeL=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 460 -90 0 0 {name=Mp
L=0.5
W=40
nf=1 mult=1
modeL=pfet_01v8
spiceprefix=X
}
C {gnd.sym} 270 10 0 0 {name=l3 lab=0}
C {gnd.sym} 480 10 0 0 {name=l5 lab=0}
C {code_shown.sym} 700 -260 0 0 {name=s1 
only_topleveL=false 
value="
* ==============================================================================
* Encabezado: Caracterizador Completo para PMOS y NMOS Sky130 (Std y LVT)
* Descripcion: Control de simulacion para extraer gm, ro, Id, Vth, Vdsat, Vov,
*              Cgg, ft y gm/Id de los 4 transistores (Mplvt, Mp, Mnlvt, Mn).
* ==============================================================================



* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt

* Parametros de tension de polarizacion iniciales
.param vsg = 1.027
.param vgs = 0.6

* Parametros de dimensiones geometricas (en micrometros um)
.param wplvt = 1
.param lplvt = 0.35

.param wp = 1
.param lp = 0.15

.param wnlvt = 1
.param lnlvt = 0.35

.param wn = 1
.param ln = 0.15

.control
  * Forzar comportamiento estandar de SPICE para evitar errores numparam en Sky130
  set ngbehavior=ps

  save all
  
  * --- 1. GUARDAR PARAMETROS PMOS LVT (xMplvt) ---
  save @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[gm]
  save @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[gds]
  save @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[id]
  save @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[vth]
  save @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[vdsat]
  save @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[cgg]
  save @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[vgs]

  * --- 2. GUARDAR PARAMETROS PMOS ESTANDAR (xMp) ---
  save @m.xMp.msky130_fd_pr__pfet_01v8[gm]
  save @m.xMp.msky130_fd_pr__pfet_01v8[gds]
  save @m.xMp.msky130_fd_pr__pfet_01v8[id]
  save @m.xMp.msky130_fd_pr__pfet_01v8[vth]
  save @m.xMp.msky130_fd_pr__pfet_01v8[vdsat]
  save @m.xMp.msky130_fd_pr__pfet_01v8[cgg]
  save @m.xMp.msky130_fd_pr__pfet_01v8[vgs]

  * --- 3. GUARDAR PARAMETROS NMOS LVT (xMnlvt) ---
  save @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[gm]
  save @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[gds]
  save @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[id]
  save @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[vth]
  save @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[vdsat]
  save @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[cgg]
  save @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[vgs]

  * --- 4. GUARDAR PARAMETROS NMOS ESTANDAR (xMn) ---
  save @m.xMn.msky130_fd_pr__nfet_01v8[gm]
  save @m.xMn.msky130_fd_pr__nfet_01v8[gds]
  save @m.xMn.msky130_fd_pr__nfet_01v8[id]
  save @m.xMn.msky130_fd_pr__nfet_01v8[vth]
  save @m.xMn.msky130_fd_pr__nfet_01v8[vdsat]
  save @m.xMn.msky130_fd_pr__nfet_01v8[cgg]
  save @m.xMn.msky130_fd_pr__nfet_01v8[vgs]

  * Barrido DC de fuentes de voltaje Vgp (PMOS) y Vgn (NMOS) de 0V a 1.8V
  dc Vgp 0 1.8 0.01 Vgn 0 1.8 0.01

  * --- CALCULOS PMOS LVT (Mplvt) ---
  let ro_mplvt = 1 / @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[gds]
  let gm_id_mplvt = @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[gm] / @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[id]
  let ft_mplvt = @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[gm] / (2 * pi * @m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[cgg])
  let vov_mplvt = abs(@m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[vgs]) - abs(@m.xMplvt.msky130_fd_pr__pfet_01v8_lvt[vth])

  * --- CALCULOS PMOS STD (Mp) ---
  let ro_mp = 1 / @m.xMp.msky130_fd_pr__pfet_01v8[gds]
  let gm_id_mp = @m.xMp.msky130_fd_pr__pfet_01v8[gm] / @m.xMp.msky130_fd_pr__pfet_01v8[id]
  let ft_mp = @m.xMp.msky130_fd_pr__pfet_01v8[gm] / (2 * pi * @m.xMp.msky130_fd_pr__pfet_01v8[cgg])
  let vov_mp = abs(@m.xMp.msky130_fd_pr__pfet_01v8[vgs]) - abs(@m.xMp.msky130_fd_pr__pfet_01v8[vth])

  * --- CALCULOS NMOS LVT (Mnlvt) ---
  let ro_mnlvt = 1 / @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[gds]
  let gm_id_mnlvt = @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[gm] / @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[id]
  let ft_mnlvt = @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[gm] / (2 * pi * @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[cgg])
  let vov_mnlvt = @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[vgs] - @m.xMnlvt.msky130_fd_pr__nfet_01v8_lvt[vth]

  * --- CALCULOS NMOS STD (Mn) ---
  let ro_mn = 1 / @m.xMn.msky130_fd_pr__nfet_01v8[gds]
  let gm_id_mn = @m.xMn.msky130_fd_pr__nfet_01v8[gm] / @m.xMn.msky130_fd_pr__nfet_01v8[id]
  let ft_mn = @m.xMn.msky130_fd_pr__nfet_01v8[gm] / (2 * pi * @m.xMn.msky130_fd_pr__nfet_01v8[cgg])
  let vov_mn = @m.xMn.msky130_fd_pr__nfet_01v8[vgs] - @m.xMn.msky130_fd_pr__nfet_01v8[vth]

  * Guardar los resultados en archivo caracterizador.raw
  set filetype=ascii
  write caracterizador.raw all
op
write caracterizador_op.raw
.endc

"
}
C {lab_wire.sym} 410 -90 0 0 {name=p2 sig_type=std_logic lab=vgp}
C {lab_wire.sym} 200 -90 2 0 {name=p3 sig_type=std_logic lab=vgp
}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 250 170 0 0 {name=Mnlvt
L=0.35
W=1
nf=1 mult=1
modeL=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 460 170 0 0 {name=Mn
L=0.15
W=1
nf=1 mult=1
modeL=nfet_01v8
spiceprefix=X
}
C {gnd.sym} 270 280 0 0 {name=l1 lab=0}
C {gnd.sym} 480 280 0 0 {name=l2 lab=0}
C {vsource.sym} 160 220 0 0 {name=Vgn value=\{vgs\} savecurrent=false}
C {lab_wire.sym} 420 -170 0 0 {name=p1 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 370 110 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 160 170 0 0 {name=p5 sig_type=std_logic lab=vgn}
C {lab_wire.sym} 410 170 0 0 {name=p6 sig_type=std_logic lab=vgn}
