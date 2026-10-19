#!/bin/bash
# =====================================================================
# pex_ota.sh - Extracción PEX completa (R + C parásitas) del OTA con Magic
# - Aplana el layout (extresist no funciona en jerárquico)
# - Recrea los puertos en el mismo orden que el símbolo de xschem
# - Extrae resistencias de TODAS las redes (extresist all)
# =====================================================================
# OJO: 'EOF' entre comillas para que bash NO reemplace $name ni $i
magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc << 'EOF'
crashbackups stop
drc off
# 1. Cargar el GDS
gds read OTA.gds
load OTA
select top cell
# 2. Aplanar y renombrar la celda plana como OTA
flatten OTA_flat
load OTA_flat
cellname delete OTA
cellname rename OTA_flat OTA
select top cell
# 3. Recrear puertos en el orden del símbolo: VDD VO_ota VIN_ota VIP_ota VSS VGN
set i 1
foreach name {VDD VO_ota VIN_ota VIP_ota VSS VGN} {
  goto $name
  port make $i
  incr i
}
select top cell
# 4. Extracción con resistencias
ext2spice lvs
extract do resistance
extract all
ext2sim labels on
ext2sim
extresist tolerance 10
extresist all
# 5. Exportar SPICE con R y C parásitas
ext2spice extresist on
ext2spice cthresh 0.01
ext2spice -o OTA_pex.spice
quit -noprompt
EOF
# Limpiar archivos intermedios
rm -f *.ext *.sim *.res.ext *.nodes

