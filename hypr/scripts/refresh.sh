#!/usr/bin/env bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
killall waybar

sleep 0.2
# Relaunch waybar
/home/felix/.config/hypr/scripts/update-monitor.sh &
uwsm app -- waybar > /dev/null 2>&1 &

notify-send "notificacion" "desde refresh script" &
# reload swaync
sleep 0.2
swaync-client -R -rs &

wal -i "/home/felix/.current_wallpaper" -s &


