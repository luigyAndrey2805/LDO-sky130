#!/bin/bash
# ==============================================================================
# Encabezado del archivo: pex_self_bias.sh
# Descripción:
#   Este script automatiza la extracción de parásitos (PEX: resistencias R y
#   capacitancias C parásitas) del bloque generador de referencia de corriente
#   auto-polarizado (self_bias) utilizando la herramienta Magic VLSI y el PDK
#   SkyWater 130nm (sky130A).
#
# Funcionamiento:
#   1. Lee el archivo de layout GDSII (sel_bias.gds) y carga la celda self_bias.
#   2. Aplana la jerarquía (flatten), requisito obligatorio en Magic para que
#      el comando 'extresist' pueda extraer resistencias parásitas correctamente.
#   3. Recrea los puertos externos en el mismo orden definido en el símbolo de
#      Xschem (VDD VR VSS) para garantizar compatibilidad en simulación.
#   4. Ejecuta la extracción de dispositivos, capacitancias y resistencias de
#      todas las redes y exporta el subcircuito final a 'self_bias_pex.spice'.
# ==============================================================================

# NOTA: Se usa 'EOF' con comillas simples para evitar que Bash expanda las
# variables internas de Tcl ($name y $i) antes de enviarlas a Magic.
magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc << 'EOF'
# Desactivar copias de respaldo de emergencia y el chequeo DRC en segundo plano
# para acelerar el procesamiento en modo batch
crashbackups stop
drc off

# 1. Usar 'gds flatglob' antes de leer el GDS para que Magic aplane las
#    subceldas de anillos de guarda (*guard_ring*) y vías (*vias*) directamente
#    dentro de la celda padre self_bias DURANTE la importación del GDS.
#    Esto es indispensable porque guard_ring_gen tiene tap+nsdm+licon pero el
#    pozo nwell (64/20) está en la celda padre; así Magic reconoce el contacto
#    ntap correctamente y conecta el pozo N de los PMOS de arranque a VDD.
gds flatglob *guard_ring*
gds flatglob *vias*
gds flatten true
gds read sel_bias.gds
load self_bias
select top cell

# 2. Aplanar la jerarquía y renombrar la celda plana con el nombre original (self_bias)
flatten self_bias_flat
load self_bias_flat
cellname delete self_bias
cellname rename self_bias_flat self_bias
select top cell

# 3. Recrear los puertos en el orden exacto del símbolo de Xschem: VDD VR VSS
set i 1
foreach name {VDD VR VSS} {
  goto $name
  port make $i
  incr i
}
select top cell

# 4. Configurar formato LVS y extraer dispositivos, capacitancias y resistencias (R+C)
ext2spice lvs
extract do resistance
extract all
ext2sim labels on
ext2sim
extresist tolerance 10
extresist all

# 5. Exportar el netlist SPICE final incluyendo resistencias y capacitancias parásitas
ext2spice extresist on
ext2spice cthresh 0.01
ext2spice -o self_bias_pex.spice
quit -noprompt
EOF

# Limpiar los archivos temporales generados por Magic durante la extracción
rm -f *.ext *.sim *.res.ext *.nodes
