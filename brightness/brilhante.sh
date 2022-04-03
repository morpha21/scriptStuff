#!/bin/bash 

arquivo='/sys/class/backlight/amdgpu_bl0/brightness'
luz=`cat $arquivo`

if [ $1 == 'mais' ];then
    echo "$((luz+21))" | tee $arquivo
elif [ $1 == 'menas' ]; then
    echo $[`cat $arquivo` - 12] | tee $arquivo
else
    echo "tu tá doido? vai se foder"
fi
