#!/bin/bash
# Written by Jack Abdo

PRODUCT=$1
FLASHTYPE=$2
FILENAME=$3

#Product=ATm32U4DFU
#Flashtype=atmega32u4
#Filename=~/Documents/qmk60.hex
#check for these three vars first
#put
echo "Warning: this script is given without any implied or expressed warranty."
echo "User assumes all risk from usage."
read -p "Assume risk? y/N" usrcnfrm
if [[ $usrcnfrm != [yY] ]]; then
  exit 1
fi
CHECKSUDO=$(sudo whoami)
if [[ "$CHECKSUDO" != "root" ]]; then
  echo "Sudo priviledges required."
  exit 2
fi

echo "Please reset keyboard now."
until [[ $(dmesg | tail | grep -i "$PRODUCT") ]]; do
  sleep .25
done

echo "Erasing memory..."
sleep 1 #wait until keyboard mounts
echo "dfu-programmer "$FLASHTYPE" erase'"
dfu-programmer "$FLASHTYPE" erase
echo "Flashing memory..."
echo "dfu-programmer "$FLASHTYPE" flash "$FILENAME""
dfu-programmer "$FLASHTYPE" flash "$FILENAME"
echo "Reseting keyboard..."
echo "dfu-programmer "$FLASHTYPE" reset"
dfu-programmer "$FLASHTYPE" reset
echo "Keyboard is now available."
