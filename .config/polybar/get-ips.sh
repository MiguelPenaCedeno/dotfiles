#!/bin/bash

# Check for VPN interfaces (tun0 for OpenVPN, wg0 for WireGuard)
vpn_ip=$(ip -4 addr show dev tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
if [ -z "$vpn_ip" ]; then
    vpn_ip=$(ip -4 addr show dev wg0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
fi

# Get local LAN IP
local_ip=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}' | tr -d '\n')

if [ -z "$local_ip" ]; then
    echo "No connection"
    exit 0
fi

# Get public IP
public_ip=$(curl -s -m 2 ifconfig.me)

if [ -z "$public_ip" ]; then
    public_ip="offline"
fi

# Output format
if [ -n "$vpn_ip" ]; then
    # If VPN is active, display it first in striking red (#ff003c) so it's obvious!
    echo "%{F#f7768e} VPN: $vpn_ip%{F-} | L: $local_ip | P: $public_ip"
else
    echo "L: $local_ip | P: $public_ip"
fi
