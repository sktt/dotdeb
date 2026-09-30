#!/bin/zsh

OUTPUT="/devices/0/outputs/4"
STEP=0.02
SLEEP=0.05

function get_monlevel {
  (echo -en "get $OUTPUT/CRMonitorLevelTapered/value\0"; sleep $SLEEP) | nc 127.0.0.1 4710 | jq '.data'
}

function set_monlevel {
  local val="$1"
  echo -en "set $OUTPUT/CRMonitorLevelTapered/value $val\0" | nc 127.0.0.1 4710
}

function mute {
  cur=$((echo -en "get $OUTPUT/Mute/value\0"; sleep $SLEEP) | nc 127.0.0.1 4710 | jq -r '.data')
  if [[ "$cur" == "true" ]]; then
    next="false"
  else
    next="true"
  fi
  echo -en "set $OUTPUT/Mute/value $next\0" | nc 127.0.0.1 4710
}

function inc_monlevel {
  cur=$(get_monlevel)
  new=$(( cur + STEP ))
  if (( new > 1 )); then
    new=1
  fi
  set_monlevel "$new"
}

function dec_monlevel {
  cur=$(get_monlevel)
  new=$(( cur - STEP ))
  if (( new < 0 )); then
    new=0
  fi
  set_monlevel "$new"
}

# argument parsing
case "$1" in
  volup)
    inc_monlevel
    ;;
  voldn)
    dec_monlevel
    ;;
  mute)
    mute
    ;;
  get)
    get_monlevel
    ;;
  *)
    echo "Usage: $0 {volup|voldn|mute|get}"
    exit 1
    ;;
esac
