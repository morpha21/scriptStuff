#!/bin/bash


battery=$(acpi | awk -F", " '{print$2}')


echo $battery