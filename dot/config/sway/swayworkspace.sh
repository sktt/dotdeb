#!/usr/bin/env bash

WSS=( ${@:3} )

function navigate {
    cur=$(swaymsg -t get_workspaces | jq --raw-output '. | map(select(.focused == true))[0].name')
    len=${#WSS[@]}
    for i in ${!WSS[@]}; do
        if [[ "${WSS[$i]}" == "$cur" ]]; then
            break
        fi
    done
    if [[ $1 == "next" ]]; then
        ws_num=$[(i+1)%len]
    elif [[ $1 == "previous" ]]; then
        ws_num=$[(i-1)%len]
    fi
    ws_name=${WSS[$ws_num]}
    swaymsg "workspace $ws_name"
}

if [[ $1 == "navigate" ]]; then
    navigate $2
else
    echo "unknown command"
    exit 1
fi
