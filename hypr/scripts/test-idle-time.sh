#!/bin/bash

# Alternativas para detectar idle time en Hyprland/Wayland
# Ya que loginctl no funciona, aquí tienes 3 métodos alternativos

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}=== Alternativas para detectar idle time en Hyprland ===${NC}"
echo ""
echo "Como loginctl no funciona, aquí tienes 3 métodos alternativos:"
echo ""

# MÉTODO 1: Script con hypridle que actualiza un archivo de timestamp
echo -e "${BLUE}MÉTODO 1: Script con hypridle + timestamp${NC}"
echo ""
echo "1. Crear archivo de configuración hypridle:"
cat << 'EOF'
# ~/.config/hypr/hypridle.conf
general {
    ignore_dbus_inhibit = false
}

# Actualiza timestamp cada segundo durante actividad
listener {
    timeout = 1
    on-resume = echo $(date +%s) > /tmp/last_activity_time
}
EOF

echo ""
echo "2. Script para leer el tiempo de idle:"
cat << 'EOF'
#!/bin/bash
# get_idle_time.sh

if [ ! -f /tmp/last_activity_time ]; then
    echo "0"
    exit 0
fi

last_activity=$(cat /tmp/last_activity_time 2>/dev/null || echo $(date +%s))
current_time=$(date +%s)
idle_time=$((current_time - last_activity))

echo "$idle_time"
EOF

echo ""
echo -e "${GREEN}Uso: ./get_idle_time.sh${NC}"
echo ""

# MÉTODO 2: Script con swayidle
echo -e "${BLUE}MÉTODO 2: Script con swayidle${NC}"
echo ""
echo "1. Instalar swayidle:"
echo "   sudo pacman -S swayidle"
echo ""
echo "2. Script para monitorear con swayidle:"
cat << 'EOF'
#!/bin/bash
# idle_monitor.sh

IDLE_FILE="/tmp/idle_status"
echo "0" > "$IDLE_FILE"

# Función para manejar idle
handle_idle() {
    echo "$(date +%s)" > "$IDLE_FILE"
}

# Función para manejar resume
handle_resume() {
    echo "0" > "$IDLE_FILE"
}

# Exportar funciones para que swayidle las pueda usar
export -f handle_idle handle_resume

# Ejecutar swayidle en background
swayidle -w \
    timeout 1 'bash -c handle_idle' \
    resume 'bash -c handle_resume' &

SWAYIDLE_PID=$!

# Script para leer idle time
get_current_idle() {
    if [ ! -f "$IDLE_FILE" ]; then
        echo "0"
        return
    fi
    
    idle_start=$(cat "$IDLE_FILE")
    
    if [ "$idle_start" = "0" ]; then
        echo "0"
    else
        current_time=$(date +%s)
        idle_time=$((current_time - idle_start))
        echo "$idle_time"
    fi
}

# Cleanup al salir
trap 'kill $SWAYIDLE_PID 2>/dev/null; rm -f "$IDLE_FILE"' EXIT

# Bucle principal para mostrar tiempo de idle
while true; do
    idle_seconds=$(get_current_idle)
    
    if [ "$idle_seconds" -gt 0 ]; then
        hours=$((idle_seconds / 3600))
        minutes=$(((idle_seconds % 3600) / 60))
        secs=$((idle_seconds % 60))
        
        if [ $hours -gt 0 ]; then
            printf "\rIdle time: %dh %dm %ds" $hours $minutes $secs
        elif [ $minutes -gt 0 ]; then
            printf "\rIdle time: %dm %ds" $minutes $secs
        else
            printf "\rIdle time: %ds" $secs
        fi
    else
        printf "\rIdle time: Active"
    fi
    
    sleep 1
done
EOF

echo ""
echo -e "${GREEN}Uso: ./idle_monitor.sh${NC}"
echo ""

# MÉTODO 3: Simple con detección de última actividad
echo -e "${BLUE}MÉTODO 3: Detección simple con archivos de actividad${NC}"
echo ""
echo "Script simple que detecta cambios en archivos del sistema:"
cat << 'EOF'
#!/bin/bash
# simple_idle_detector.sh

ACTIVITY_FILES=(
    "/dev/input/mice"
    "/dev/input/event*"
)

last_activity_time=$(date +%s)

get_last_file_activity() {
    local latest=0
    for file_pattern in "${ACTIVITY_FILES[@]}"; do
        for file in $file_pattern; do
            if [ -e "$file" ]; then
                local file_time=$(stat -c %Y "$file" 2>/dev/null || echo 0)
                if [ "$file_time" -gt "$latest" ]; then
                    latest=$file_time
                fi
            fi
        done
    done
    echo "$latest"
}

while true; do
    current_time=$(date +%s)
    last_file_activity=$(get_last_file_activity)
    
    # Si hay actividad reciente en archivos de input
    if [ "$last_file_activity" -gt "$last_activity_time" ]; then
        last_activity_time=$current_time
    fi
    
    idle_time=$((current_time - last_activity_time))
    
    hours=$((idle_time / 3600))
    minutes=$(((idle_time % 3600) / 60))
    secs=$((idle_time % 60))
    
    if [ $hours -gt 0 ]; then
        printf "\rIdle time: %dh %dm %ds" $hours $minutes $secs
    elif [ $minutes -gt 0 ]; then
        printf "\rIdle time: %dm %ds" $minutes $secs
    else
        printf "\rIdle time: %ds" $secs
    fi
    
    sleep 1
done
EOF

echo ""
echo -e "${GREEN}Uso: ./simple_idle_detector.sh${NC}"
echo ""

echo -e "${YELLOW}=== RECOMENDACIONES ===${NC}"
echo ""
echo -e "${GREEN}• MÉTODO 1${NC}: Más preciso, pero requiere configurar hypridle"
echo -e "${GREEN}• MÉTODO 2${NC}: Muy confiable, usa el protocolo oficial de Wayland"
echo -e "${GREEN}• MÉTODO 3${NC}: Más simple, pero puede ser menos preciso"
echo ""
echo "Todos estos métodos funcionan mejor que loginctl en Hyprland."
echo "El Método 2 (swayidle) es el más recomendado por ser el estándar."
