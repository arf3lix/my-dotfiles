#!/bin/bash

# Script simple para aplicar wallust a starship
STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
WALLUST_COLORS="$HOME/.cache/wallust/colors-starship.toml"

# Verificar archivos
[[ ! -f "$STARSHIP_CONFIG" ]] && { echo "Error: starship.toml no encontrado"; exit 1; }
[[ ! -f "$WALLUST_COLORS" ]] && { echo "Error: colors-starship.toml no encontrado"; exit 1; }

# Si existe la sección wallust, eliminarla desde esa línea hasta el final
if grep -q "^\[palettes\.wallust\]" "$STARSHIP_CONFIG"; then
    # Eliminar desde [palettes.wallust] hasta el final del archivo
    sed -i '/^\[palettes\.wallust\]$/,$d' "$STARSHIP_CONFIG"
fi

# Agregar nueva sección wallust
echo "" >> "$STARSHIP_CONFIG"
cat "$WALLUST_COLORS" >> "$STARSHIP_CONFIG"

