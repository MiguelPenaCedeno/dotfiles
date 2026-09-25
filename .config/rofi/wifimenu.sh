#!/bin/sh
# quick wifi picker for NetworkManager, using rofi

iface=$(nmcli -t -f DEVICE,TYPE device | awk -F: '$2=="wifi"{print $1; exit}')
[ -z "$iface" ] && exit 1

nmcli device wifi rescan ifname "$iface" >/dev/null 2>&1

ssid=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list ifname "$iface" \
	| awk -F: '!seen[$1]++ && $1!="" {printf "%s\t(%s%%)\n", $1, $2}' \
	| rofi -dmenu -i -p "Wi-Fi" -theme "$HOME/.config/rofi/config.rasi" \
	| cut -f1)

[ -z "$ssid" ] && exit 0

if nmcli -t -f NAME connection show | grep -qx "$ssid"; then
	nmcli connection up "$ssid"
else
	pass=$(rofi -dmenu -password -p "Password for $ssid" -theme "$HOME/.config/rofi/config.rasi")
	nmcli device wifi connect "$ssid" password "$pass" ifname "$iface"
fi

dunstify -a wifi -t 3000 "Wi-Fi" "$(nmcli -t -f GENERAL.STATE device show "$iface" | cut -d: -f2)"
