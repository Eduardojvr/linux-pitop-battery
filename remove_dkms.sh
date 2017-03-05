#! /bin/sh

dkms remove -m sbs_battery -v 1.0 --all
rm /usr/src/sbs_battery-1.0 -rvf

dkms remove -m i2c_gpio_param -v 1.0 --all
rm /usr/src/i2c_gpio_param -1.0 -rvf
