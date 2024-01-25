#!/bin/bash

# Function to detect input devices and return a list
function get_keyboard_input_devices_list() {
  # initialize a list of input devices full paths
  input_devices_list=()
  # populate in
  for device in /dev/input/event*; do
    if udevadm info -a -n "$device" | grep -q "eyboard"; then
      input_devices_list+=("$device")
    fi
  done
  echo "${input_devices_list[@]}"
}
function start_cat {
  local input_devices="$1"
  IFS=$' '
  for device in $input_devices; do
    # ../.././read-event $device
    cat -u $device $device > events &
  done
  IFS=$' \t\n'
}
function end_cat {
  local cat_processes
  cat_processes=$(ps -eo cmd,pid | egrep "^cat -u /dev/input/event[0-9][0-9]*")
  IFS=$'\n'
  ## rm -rf events
  for process in $cat_processes; do
    echo "killing proc $(echo "$process" | grep -oP '[0-9]+$'), launch_cmd = $process"
    kill -SIGTERM $(echo "$process" | grep -oP '[0-9]+$')
  done
  IFS=$' \t\n'
}

service_running=true
# Function to handle SIGINT (Ctrl+C)
function interrupt_handler {
  echo ""
  echo "Received Ctrl+C. Cleaning up and exiting..."
  # Add your cleanup code here if needed
  service_running=false
  end_cat
  exit 1
}

function main(){

  # Set a trap to call the interrupt_handler function when SIGINT is received
  trap interrupt_handler SIGINT


  current=$(pwd)
  mkdir -p /tmp/kbev
  cd /tmp/kbev
  echo "configured events service in  : /tmp/kbev"

  #ExecStartPre


  #ExecStart
  while $service_running; do

    input_devices=$(get_keyboard_input_devices_list)
    echo $input_devices > input_devices.lst
    echo "detected input devices : $input_devices"
    echo "configuring service : "
    chmod 777 input_devices.lst
    touch events
    chmod 777 events

    echo "starting cat : "
    start_cat "$input_devices"
    echo "waiting 1 hour : "
    sleep 3600
    end_cat
    ls -la events
    echo "cycle done ::::::::::::::::::::::::::::::::: $(date) "
    echo "" > events
  done
  #ExecStop=

  # Enable echoing
  # stty echo
  echo "keyboard event service exited"
  cd "$current" || exit

}

main
