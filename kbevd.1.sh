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
  stty echo
  echo "Received Ctrl+C. Cleaning up and exiting..."
  # Add your cleanup code here if needed
  service_running=false
  exit 1
}

function main(){
  min_size=1000  # Change this value to the minimum size you want to check (in bytes)
  file_path="/tmp/kbev/events"
  # Set a trap to call the interrupt_handler function when SIGINT is received
  trap interrupt_handler SIGINT
  trap interrupt_handler SIGTERM


  current=$(pwd)
  rm -rf /tmp/kbev/
  mkdir -p /tmp/kbev/
  cd /tmp/kbev
  echo "configured events service in  : /tmp/kbev"

  #ExecStartPre

  input_devices=$(get_keyboard_input_devices_list)
  echo $input_devices > input_devices.lst
  echo "detected input devices : $input_devices"
  echo "configuring service : "
  chmod 777 input_devices.lst
  rm -rf events
  touch events
  chmod 777 events
  rm -rf read.lock
  ls -la

  # Disable echoing
  stty -echo

  #ExecStart
  num_bytes=24
  while $service_running; do
      if [ -f read.lock ]
      then
        #nothing
        touch service.is.blocked
        sleep 0.01
      else
        rm -rf service.is.blocked
        touch read.lock

        rm -rf events
        for device in $input_devices; do
          pp=$(ps -eo cmd | egrep "^dd if=$device")
          if [ "$pp" == "" ];then
            echo "launching listener for $device ---> [$pp]" > /dev/null 2>&1
            dd if=$device bs=$num_bytes count=1 of="/tmp/kbev/event" status=none conv=notrunc oflag=append &
          fi
        done
        rm -rf read.lock
        # cat input_devices.lst
        rm -rf events
        echo "" > events
      fi
  done

  #ExecStop=

  # Enable echoing
  stty echo
  rm -rf service.is.blocked
  rm -rf read.lock
  echo "keyboard event service exited"
  cd $current

}

main
