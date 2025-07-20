#!/bin/bash

# Script: update_main_monitor.sh
# Uso: ./update_main_monitor.sh [nombre_monitor_principal]
# Ejemplo: ./update_main_monitor.sh DP-1

# Configuraciones
CONFIG_DIR="$HOME/.config/waybar"
CONFIG_TEMPLATE="$CONFIG_DIR/config.template.jsonc"
CONFIG_FINAL="$CONFIG_DIR/config.jsonc"
UWSM_CMD="uwsm"  # Ajusta según cómo ejecutas normalmente waybar con uwsm

# Verificar argumento
if [ -z "$1" ]; then
    echo "Error: Debes especificar el monitor principal como argumento"
    echo "Ejemplo: $0 DP-1"
    exit 1
fi

# Exportar variable de entorno con el monitor principal
export MAIN_MONITOR="$1"

# Actualizar configuración desde la plantilla
if [ ! -f "$CONFIG_TEMPLATE" ]; then
    echo "Error: No se encontró la plantilla en $CONFIG_TEMPLATE"
    exit 1
fi

echo "Actualizando configuración de Waybar..."
envsubst < "$CONFIG_TEMPLATE" > "$CONFIG_FINAL"

killall waybar &


echo "Iniciando Waybar con uwsm..."
$UWSM_CMD app -- waybar &

echo "Operación completada. Monitor principal configurado como: $MAIN_MONITOR"
