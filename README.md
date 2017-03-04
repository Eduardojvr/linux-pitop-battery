Be sure to install `raspberrypi-kernel-headers` before you try building
this module.

After loading, (as root) run
`echo pitop-battery 0x0b > /sys/class/i2c-adapter/i2c-1/new_device`.
