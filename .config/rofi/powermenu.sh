#!/bin/sh

entries="Lock\nLogout\nSuspend\nReboot\nShutdown"

selected=$(printf "%b" "$entries" | rofi -dmenu -i -p "Power" -theme "$HOME/.config/rofi/config.rasi")

case "$selected" in
	Lock) i3lock -c 000000 ;;
	Logout) bspc quit ;;
	Suspend) systemctl suspend ;;
	Reboot) systemctl reboot ;;
	Shutdown) systemctl poweroff ;;
esac
