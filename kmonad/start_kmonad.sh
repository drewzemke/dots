#!/bin/bash
#
# this script is only needed for arch
apple_keyboard="usb-Apple__Inc_Apple_Keyboard-event-kbd"
corne_keyboard="usb-foostan_Corne-event-kbd"

if [[ -e "/dev/input/by-id/${corne_keyboard}" ]]; then
  /usr/local/bin/kmonad --input "device-file \"/dev/input/by-id/${corne_keyboard}\"" /home/drew/.config/kmonad/config.kbd
elif [[ -e "/dev/input/by-id/${apple_keyboard}" ]]; then
  /usr/local/bin/kmonad --input "device-file \"/dev/input/by-id/${apple_keyboard}\"" /home/drew/.config/kmonad/config.kbd 
fi
