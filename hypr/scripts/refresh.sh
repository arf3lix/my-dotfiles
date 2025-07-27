#!/usr/bin/env bash


wal -i "/home/felix/.current_wallpaper" -s

killall hyprpaper
killall waybar

/home/felix/.config/hypr/scripts/update-monitor.sh

sleep 0.2
# Relaunch waybar and hyprpaper
uwsm app -- waybar > /dev/null 2>&1 &
uwsm app -- hyprpaper &
# reload swaync
sleep 0.2
swaync-client -R
swaync-client -rs

/home/felix/.config/hypr/scripts/starship-wallust.sh
/home/felix/.config/hypr/scripts/blesh-wallust.sh

source ~/.bashrc

sleep 0.2
hyprctl dispatch sendshortcut CTRL+SHIFT, comma, "class:(com.mitchellh.ghostty)" #reload ghostty config
hyprctl reload


