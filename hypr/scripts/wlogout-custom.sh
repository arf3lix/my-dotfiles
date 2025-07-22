#!/bin/bash

# Script para ejecutar wlogout con escala temporal 1.0
# Solo hace el rescalado si ÚNICAMENTE está activo el monitor eDP-1
# Si hay múltiples monitores, ejecuta wlogout normalmente

# Obtener monitores activos
active_monitors=$(hyprctl monitors -j | jq -r '.[].name')
monitor_count=$(echo "$active_monitors" | wc -l)

# Verificar si solo está activo eDP-1
if [[ $monitor_count -eq 1 && "$active_monitors" == "eDP-1" ]]; then
    echo "Solo eDP-1 activo, aplicando fix de escala temporal..."
    
    # Obtener configuración actual del eDP-1
    current_scale=$(hyprctl monitors -j | jq -r '.[] | select(.name=="eDP-1") | .scale')
    
    # Cambiar eDP-1 a escala 1.0 temporalmente
    #hyprctl keyword monitor "eDP-1,preferred,auto,1"
    
    # Pequeña pausa para que se aplique el cambio
    sleep 0.2
    
    # Ejecutar wlogout
    wlogout -C $HOME/.config/wlogout/nova.css -l $HOME/.config/wlogout/layout -b 5 -B 400 -T 400
    
    # Restaurar escala original del eDP-1
    # hyprctl keyword monitor "eDP-1,preferred,auto,$current_scale"
    
else
    echo "Múltiples monitores detectados, ejecutando wlogout normalmente..."
    
    # Ejecutar wlogout sin cambios de escala
    wlogout -C $HOME/.config/wlogout/nova.css -l $HOME/.config/wlogout/layout -b 5 -B 400 -T 400
fi
