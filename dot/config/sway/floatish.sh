#!/usr/bin/env bash
# github : Synthetica9/sway-floating

$@ &
pid=$!

swaymsg -t subscribe -m '[ "window" ]' \
  | jq --unbuffered --argjson pid "$pid" '.container | select(.pid == $pid) | .id' \
  | xargs -I '@' -- swaymsg '[ con_id=@ ] floating enable' &

subscription=$!

tail --pid=$pid -f /dev/null

kill $subscription
