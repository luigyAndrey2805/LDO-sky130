#!/bin/bash
# ==============================================================================
# Encabezado del archivo: extract_pex_ldo.sh
# Descripción:
#   Este script automatiza la extracción de parásitos completa (PEX: resistencias
#   R y capacitancias C parásitas) del regulador LDO completo (LDO.gds), el cual
#   integra el amplificador de error (OTA), la referencia de corriente (self_bias),
#   el transistor de paso PMOS (M1), el divisor resistivo (R1, R11, R2) y el
#   capacitor de compensación (C1), utilizando Magic VLSI y el PDK sky130A.
#
# Funcionamiento:
#   1. Aplana durante la lectura del GDS ('gds flatglob') las subceldas de anillos
#      de guarda (*guard_ring*) y vías (*vias*) para que Magic fusione los contactos
#      de sustrato/pozo (ntap/ptap) con el pozo nwell (64/20) de las celdas padre
#      (indispensable para el transistor de paso M1 y los PMOS de self_bias).
#   2. Aplana toda la jerarquía del LDO (requisito obligatorio en Magic para que
#      'extresist' extraiga las resistencias parásitas de todas las redes).
#   3. Recrea los 5 puertos externos en el orden exacto definido en el símbolo
#      LDO.sym de Xschem: VIN VOUT VDD Vref(Vre) VSS.
#   4. Extrae dispositivos, capacitancias y resistencias parásitas y genera el
#      archivo final 'LDO_pex.spice' listo para simulación post-layout.
# ==============================================================================

# NOTA: Se utiliza 'EOF' entre comillas simples para evitar que Bash evalúe
# variables o símbolos especiales antes de pasarlos al intérprete Tcl de Magic.
magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc << 'EOF'
# Desactivar respaldos automáticos y el verificador DRC en tiempo real para
# acelerar la ejecución en modo batch
crashbackups stop
drc off

# 1. Pre-aplanar anillos de guarda (*guard_ring*) y generadores de vías (*vias*)
#    durante la importación del archivo GDSII. Esto garantiza que los contactos
#    de pozo (ntap) de M1 y de self_bias queden dentro del mismo nivel que su
#    capa nwell (64/20) y se conecten correctamente a VDD.
gds flatglob *guard_ring*
gds flatglob *vias*
gds flatten true

# Leer el layout completo del LDO y seleccionar la celda principal
gds read LDO.gds
load LDO
select top cell

# 2. Aplanar toda la jerarquía (OTA, self_bias y dispositivos de nivel superior)
#    en una única celda plana y renombrarla nuevamente como 'LDO'
flatten LDO_flat
load LDO_flat
cellname delete LDO
cellname rename LDO_flat LDO
select top cell

# 3. Recrear los puertos en el orden exacto del símbolo LDO.sym de Xschem:
#    Orden de pines en LDO.sym: 1=VIN, 2=VOUT, 3=VDD, 4=Vref, 5=VSS
#    Puerto 1: Entrada no regulada (VIN)
goto VIN
port make 1

#    Puerto 2: Salida regulada del LDO (VOUT)
goto VOUT
port make 2

#    Puerto 3: Alimentación positiva (VDD)
goto VDD
port make 3

#    Puerto 4: Voltaje de referencia (Vref).
#    En LDO.gds la etiqueta de texto en met3.label (70/5) se llamó 'Vre';
#    se buscan ambos nombres ('Vre' y 'Vref') para que funcione tanto con la
#    etiqueta actual 'Vre' como si se renombra a 'Vref'.
goto Vre
goto Vref
port make 4

#    Puerto 5: Tierra / referencia negativa (VSS)
goto VSS
port make 5

select top cell

# 4. Configurar extracción estilo LVS y calcular resistencias y capacitancias
ext2spice lvs
extract do resistance
extract all
ext2sim labels on
ext2sim
extresist tolerance 10
extresist all

# 5. Exportar el netlist SPICE final con resistencias (R) y capacitancias (C)
ext2spice extresist on
ext2spice cthresh 0.01
ext2spice -o LDO_pex.spice
quit -noprompt
EOF

# Limpiar los archivos auxiliares intermedios generados por Magic
rm -f *.ext *.sim *.res.ext *.nodes
