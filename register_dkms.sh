#! /bin/sh

cp -rv modules/sbs-battery /usr/src/sbs_battery-1.0
dkms add -m sbs_battery -v 1.0
dkms build -m sbs_battery -v 1.0 && dkms install -m sbs_battery -v 1.0


cp -rv modules/i2c-gpio-param /usr/src/i2c_gpio_param-1.0
cp -v modules/i2c_gpio_param.dkms.conf /usr/src/i2c_gpio_param-1.0/dkms.conf

echo 'KERNELRELEASE ?= $(shell uname -r)' > /usr/src/i2c_gpio_param-1.0/Makefile
echo 'KDIR ?= "/lib/modules/$(KERNELRELEASE)/build"' >> /usr/src/i2c_gpio_param-1.0/Makefile
cat modules/i2c-gpio-param/Makefile >> /usr/src/i2c_gpio_param-1.0/Makefile

dkms add -m i2c_gpio_param -v 1.0
dkms build -m i2c_gpio_param -v 1.0 && dkms install -m i2c_gpio_param -v 1.0
