#!/bin/bash


killall yambar
PID_FILE=~/.config/yambar/yambar.pid

if [ -f $PID_FILE ]; then
  kill -QUIT $(<$PID_FILE)
  rm $PID_FILE
fi

yambar -p $PID_FILE & disown
