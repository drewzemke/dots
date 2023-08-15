#!/bin/bash

device_name="usb-Apple__Inc_Apple_Keyboard-event-kbd"

if [[ -e "/dev/input/by-id/${device_name}" ]]; then
  /usr/bin/kmonad /home/drew/.config/kmonad/drew.kbd
fi


 