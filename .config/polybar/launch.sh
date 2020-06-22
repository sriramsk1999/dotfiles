#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch bars
echo "---" | tee -a /tmp/i3plasma.log
polybar rightpanel >>/tmp/i3plasma.log 2>&1 &
polybar leftpanel >>/tmp/i3plasma.log 2>&1 &
polybar centerpanel >>/tmp/i3plasma.log 2>&1 &

echo "Bar launched..."
