#!/bin/bash

# Function to detect input devices and return a list
get_keyboard_input_devices_list() {
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

service_running=true
# Function to handle SIGINT (Ctrl+C)
interrupt_handler() {
  echo "Received Ctrl+C. Cleaning up and exiting..."
  # Add your cleanup code here if needed
  service_running=false
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

  input_devices=$(get_keyboard_input_devices_list)
  echo $input_devices > input_devices.lst
  echo "detected input devices : $input_devices"
  echo "configuring service : "
  chmod 777 input_devices.lst
  touch events
  chmod 777 events
  rm -rf read.lock
  ls -la

  # Disable echoing
  # stty -echo
  for device in $input_devices; do
    # ../.././read-event $device
    cat -u $device $device > events &
  done

  #ExecStart
  while $service_running; do
    pseo=$(ps -eo cmd,pid | egrep "^cat -u /dev/input/event[0-9][0-9]*")
    IFS=$'\n'
    ## rm -rf events
    for process in $pseo; do
      IFS=$'\t'
      read -ra proc <<< "$process"
      echo "proc ${proc[1]}, launch_cmd = ${proc[0]}"
    done
    sleep 20
  done

    pseo=$(ps -eo cmd,pid | egrep "^cat -u /dev/input/event[0-9][0-9]*")
    IFS=$'\n'
    ## rm -rf events
    for process in $pseo; do
      IFS=$'\t'
      read -ra proc <<< "$process"
      echo "killing proc ${proc[1]}, launch_cmd = ${proc[0]}"
      kill -SIGTERM "${proc[1]}"
    done
  #ExecStop=

  # Enable echoing
  # stty echo
  echo "keyboard event service exited"
  cd $current

}

main
