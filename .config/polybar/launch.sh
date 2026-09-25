#!/bin/sh

# terminate already running instances
killall -q polybar

# wait for the process to be fully terminated
while pgrep -x polybar >/dev/null; do sleep 1; done

polybar main -c "$HOME/.config/polybar/config.ini" &
