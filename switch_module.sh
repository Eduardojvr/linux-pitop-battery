#!/bin/sh
echo 'Unregistering battery...'
echo 0x0b > /sys/class/i2c-adapter/i2c-1/delete_device
echo 'Unloading old version...'
rmmod pitop_battery
echo 'Loading new version...'
insmod ./pitop-battery.ko
echo 'Registering battery...'
echo pitop-battery 0x0b > /sys/class/i2c-adapter/i2c-1/new_device
