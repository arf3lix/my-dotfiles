#!/bin/bash

# --- Obtener el monitor (orden de prioridad: $1 > /tmp/main_monitor > "eDP-1") ---
if [ -n "$1" ]; then
    MAIN_MONITOR="$1"
else
    MAIN_MONITOR=$(cat /tmp/main_monitor 2>/dev/null || echo "eDP-1")
fi

# --- Ruta de la configuración de Waybar ---
BASE_CONFIG="$HOME/.config/waybar/config.jsonc"

# --- Actualizar la configuración ---
if grep -q "\"output\":" "$BASE_CONFIG"; then

    echo "Reemplazando propiedad 'output' con: $MAIN_MONITOR"
    sed -i "s/\"output\": \"[^\"]*\"/\"output\": \"$MAIN_MONITOR\"/" "$BASE_CONFIG"
else
    echo "Insertando propiedad 'output': $MAIN_MONITOR (no existía previamente)"
    sed -i "0,/{/s/{/{\n\"output\": \"$MAIN_MONITOR\",/" "$BASE_CONFIG"
fi
notify-send "updating monitor" "from script"
