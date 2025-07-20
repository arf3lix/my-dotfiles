#!/bin/bash 

# Define el comando de Rofi
ROFI_COMMAND="rofi -show drun -modi drun,filebrowser,run,window -theme-str '#window { fullscreen: true; }'"

# Busca un proceso de Rofi existente
if pgrep -x "rofi" > /dev/null; then
    # Si Rofi está abierto, lo cierra
    killall -SIGTERM rofi
else
    # Si Rofi no está abierto, lo lanza en segundo plano
    eval "$ROFI_COMMAND" &
fi
