v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {code_shown.sym} -200 -420 0 0 {name="s1" 
only_topleveL=false 
value="


.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt_mm
.option temp=27
.option num_threads=8


* Forzar un punto de partida para ayudar a la convergencia
.nodeset V(VO)=1.2
.nodeset V(x1.Vre)=0.6

.options RELTOL=1e-3
.options ABSTOL=1e-6
.options VNTOL=1e-6
.options GMIN=1e-10
.options ITL1=500


**parametros_ldo
.param VDD = 1.8
.param VREF = 0.6
.param VIN = '1*VDD'
.param RL = 240
.param CL = 1u
.param tsim = 2m
* Parámetros para la prueba de carga del LDO
.param iload_min = 1u
.param iload_max = 5m
.param tstart   = 10u
.param trise    = 100n
.param tfall    = 100n
.param twidth   = 100u
.param tperiod  = 200u

.param tsim = '3*tperiod'

.param ac_iprobe = 1
.param ac_vdd = 0 



.control
* =========================================================
* 1. CONFIGURACIÓN DEL BUCLE MONTE CARLO
* =========================================================
let mc_runs = 50
let run = 1

set appendwrite
set filetype=ascii

* En .control 'let' NO acepta comillas: se evalua directamente la expresion
let tperiod  = 200u
let tsim = '3*tperiod'

* ---> CREAR EL ARCHIVO LIMPIO ANTES DEL BUCLE <---
* El símbolo '>' crea un archivo nuevo o borra el anterior si existía
echo === INICIO MONTE CARLO === > datos_mc.txt

* =========================================================
* 2. INICIO DEL BUCLE
* =========================================================
while run <= mc_runs

    alterparam ac_iprobe = 1
    alterparam ac_vdd = 0
    alterparam RL = 240

    * Mensajes en la consola de Ngspice para que veas el progreso visual
    echo ======================================
    echo CORRIENDO MONTE CARLO ITERACION: $&run
    echo ======================================

    * Guardamos un separador de iteración en el archivo de texto
    echo --- ITERACION: $&run --- >> datos_mc.txt

    * Tira los dados estadísticos para crear un nuevo chip
    reset

    * -----------------------------------------------------
    * B. TRANSIENTE (Overshoot y Undershoot)
    * -----------------------------------------------------
    tran 1u $&tsim uic
    write LDO_mc_tran.raw

    meas tran v_estable_ligera FIND v(vo) AT=5u
    meas tran v_estable_pesada FIND v(vo) AT=200u
    meas tran vo_max MAX v(vo)
    meas tran vo_min MIN v(vo)
    meas trab salida_tran avg v(vo) from=1u to=$&tsim

    let undershoot_mV = (v_estable_ligera - vo_min) * 1e3
    let overshoot_mV = (vo_max - v_estable_pesada) * 1e3
    

    * Escribimos los datos en el archivo .txt usando '>>'
    echo 'undershoot_mV = $&undershoot_mV' >> datos_mc.txt
    echo 'overshoot_mV = $&overshoot_mV' >> datos_mc.txt
    echo 'salida_tran = $&v_estable_pesada' >> datos_mc.txt 
    * -----------------------------------------------------
    * C. AC (Estabilidad y Ganancia de Lazo Abierto)
    * -----------------------------------------------------
    ac dec 10 1 1G
    * 1. Ganancia de Lazo Abierto T(s) = v(x1.vre) / v(x1.vre2)
    let T_loop = v(x1.vre) / v(x1.vre2)
    let ldb = vdb(T_loop)
    let fase = vp(T_loop) * 180 / pi

    write LDO_mc_ac_estability.raw

    meas ac ugb WHEN ldb = 0.0
    meas ac fase_ugb FIND fase WHEN ldb = 0.0
    let margen_fase = fase_ugb
    meas ac ganancia_banda_plana find ldb at=1

    echo 'margen_fase = $&margen_fase' >> datos_mc.txt
    echo 'ganancia_banda_plana = $&ganancia_banda_plana' >> datos_mc.txt
    echo 'ugb = $&ugb' >> datos_mc.txt

    * -----------------------------------------------------
    * D. DC (Line Regulation)
    * -----------------------------------------------------
    dc vin 1.45 1.8 0.01
    write LDO_mc_dc_line.raw

    meas dc voline_max MAX v(vo)
    meas dc voline_min MIN v(vo)
    meas dc salida_line avg v(vo) from=1.45 to=1.8
    let line_regulation_mV = (voline_max - voline_min)*1000

    echo 'line_regulation = $&line_regulation_mV' >> datos_mc.txt
    echo 'salida_line = $&salida_line_mv' >> datos_mc.txt
    * -----------------------------------------------------
    * E. AC (PSRR)
    * -----------------------------------------------------
    alterparam ac_iprobe = 0
    alterparam ac_vdd = 1
    reset
    ac dec 10 1 1G
    let psrr1 = v(vdd)/v(vo)
    let psrr_db = vdb(psrr1)
    write LDO_mc_ac_psrr.raw

    meas ac gananciaPSRR_1   find psrr_db at=1
    meas ac gananciaPSRR_1k  find psrr_db at=1k
    meas ac gananciaPSRR_10k find psrr_db at=10k
    meas ac gananciaPSRR_1M  find psrr_db at=1Meg

    echo 'psrr_1 = $&gananciaPSRR_1' >> datos_mc.txt
    echo 'psrr_1k = $&gananciaPSRR_1k' >> datos_mc.txt
    echo 'psrr_10k = $&gananciaPSRR_10k' >> datos_mc.txt
    echo 'psrr_1M = $&gananciaPSRR_1M' >> datos_mc.txt



    * -----------------------------------------------------
    * G. DC (Dropout)
    * -----------------------------------------------------
    alterparam RL = 240
    reset
    dc vin1 0 2 0.01
    write LDO_mc_dc_dropout.raw

    meas dc vout_nom FIND v(vo) WHEN vi = 1.50
    let vout_target = vout_nom * 0.95
    meas dc vin_do FIND vi WHEN vo = vout_target fall=1
    let dropout_mV = (vin_do - vout_target) * 1e3

    echo 'dropout_mV = $&dropout_mV' >> datos_mc.txt

    * Avanzamos el contador del bucle
    let run = run + 1
end

* Al terminar, imprimimos que finalizó
echo ======================================
echo SIMULACION MONTE CARLO FINALIZADA
echo ======================================
echo === FIN MONTE CARLO === >> datos_mc.txt

.endc

"
}
C {code_shown.sym} -1640 -1100 0 0 {name=s2
only_topleveL=false 
value="



* 1. Inclusión de libreria de modelos Sky130 PRIMERO
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice ff
.option temp=-40
.option num_threads=8


* Forzar un punto de partida para ayudar a la convergencia
.nodeset V(VO)=1.2
.nodeset V(x1.Vre)=0.6

.options RELTOL=1e-3
.options ABSTOL=1e-6
.options VNTOL=1e-6
.options GMIN=1e-10
.options ITL1=500


**parametros_ldo
.param VDD = 1.8
.param VREF = 0.6
.param VIN = '1*VDD'
.param RL = 240
.param CL = 1u
.param tsim = 2m
* Parámetros para la prueba de carga del LDO
.param iload_min = 1u
.param iload_max = 5m
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
alterparam ac_iprobe = 1
alterparam ac_vdd = 0
reset 
ac dec 10 1 1G
* 1. Ganancia de Lazo Abierto T(s) = v(x1.vre) / v(x1.vre2)
let T_loop = v(x1.vre) / v(x1.vre2)
let ldb = vdb(T_loop)
let fase = vp(T_loop) * 180 / pi

write LDO_ac_estability.raw


* 5. Analisis en dc sweep para el line regulation 
dc vin 1.46 1.74 0.05
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



* ANALISIS EN DC PARA EL DROPOUT
alterparam RL = 240
reset 
dc vin1 0 2 0.05
write LDO_dc_dropout.raw




*CALCULOS PARA ESTABILIDAD Y GANANCIA EN LAZO ABIERTO 

setplot ac1
* 2. UGB (Frecuencia donde la magnitud cruza 0 dB)
meas ac ugb WHEN ldb = 0.0
* 3. Medir la fase en grados en el punto exacto del UGB
meas ac fase_ugb FIND fase WHEN ldb = 0.0

* 4. Calcular el Margen de Fase (PM = fase_ugb)
let margen_fase = fase
meas ac ganancia_banda_plana   find ldb at=1
echo 'margen_fase = $&fase_ugb'

*CALCULOS PARA EL PSRR
setplot ac2
meas ac gananciaPSRR_1   find psrr_db at=1
meas ac gananciaPSRR_1k  find psrr_db at=1k
meas ac gananciaPSRR_10k find psrr_db at=10k
meas ac gananciaPSRR_1M  find psrr_db at=1Meg



*CALCULOS PARA EL LINE REGULATION 
setplot dc1
meas dc voline_max MAX v(vo)
meas dc voline_min MIN v(vo)
let line_regulation = voline_max - voline_min

meas dc salida_line avg v(vo) from=1.45 to=1.8
echo 'line_regulation = $&line_regulation'
echo 'salida_line = $&salida_line'

*CALCULOS PARA EL DROPOUT
setplot dc2

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
