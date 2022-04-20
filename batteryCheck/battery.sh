#!/bin/bash


while [ true ]
do 
	battery=$(acpi | awk -F", " '{print$2}' | sed 's/%//g') 
	if [ $battery -le 6 ]
	then
		notify-send "battery level is critical" "battery level is $battery, and computer will shutdown in 1 and a half minute, unless it is charging"
		sleep 90
		[ $(acpi | awk '{print$3}' | sed 's/,//g') == "Discharging" ] && shutdown -P now
	elif [ $battery -le 28 ]
	then
		notify-send "recharge is needed" "battery level is $battery"
	fi
done
