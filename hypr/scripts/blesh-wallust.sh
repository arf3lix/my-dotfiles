#!/bin/bash
# Script para aplicar wallust a blesh
BLESH_CONFIG="$HOME/.config/blesh/blerc.sh"
WALLUST_COLORS="$HOME/.cache/wallust/colors-blesh.sh"

# Verificar archivos
[[ ! -f "$BLESH_CONFIG" ]] && { echo "Error: blerc.sh no encontrado"; exit 1; }
[[ ! -f "$WALLUST_COLORS" ]] && { echo "Error: colors-blesh.sh no encontrado"; exit 1; }

# Si existe la sección de colores wallust, eliminarla
if grep -q "^color_bg=" "$BLESH_CONFIG"; then
    # Eliminar desde color_bg hasta color8 (inclusive)
    sed -i '/^color_bg=/,/^color8=/d' "$BLESH_CONFIG"
fi

# Insertar colores wallust al inicio del archivo
{
    cat "$WALLUST_COLORS"
    echo ""  # Línea en blanco para separar
    cat "$BLESH_CONFIG"
} > "$BLESH_CONFIG.tmp" && mv "$BLESH_CONFIG.tmp" "$BLESH_CONFIG"

