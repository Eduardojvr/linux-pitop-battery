You need to replace the default i2c1 driver with a bit-banging version
in order to read the battery correctly.
Steps to do this are below.

Be sure to install `raspberrypi-kernel-headers` before you try building
this module.

## Steps to get it working

 - `git submodule init`
 - `git submodule update`
 - `sudo ./register_dkms.sh`

(To uninstall, run `sudo ./remove_dkms.sh`.)

After doing the above, you need to modify the following three files:

NOTE:
These files are for the default version of Raspbian Jessie (after running
`raspi-config`, etc.).
If you have other hardware configured, adjust accordingly.

### `/etc/modules`

Comment out all the i2c modules:

```
#i2c-dev
#i2c-bcm2708
```

### `/etc/rc.local`

```sh
#!/bin/sh -e

# register I2C
modprobe i2c-gpio-param busid=1 sda=2 scl=3
modprobe i2c-dev

# give it a moment to... initialize?
# /sys/class/i2c-adapter/i2c-1 doesn't immediately exist
sleep 2

# register Pi-Top battery
modprobe sbs-battery
echo sbs-battery 0x0b > /sys/class/i2c-adapter/i2c-1/new_device

exit 0
```

I also have an RTC connected to the hub, so I added this block right
before the battery:

```sh
# register the RTC (chronodot v2.1 connected to the Pi-Top Hub)
modprobe rtc-ds1307
echo ds3231 0x68 > /sys/class/i2c-adapter/i2c-1/new_device
```

### `/boot/config.txt`

Remove anything that might load the i2c1 driver.

Here is my file:

```
dtparam=spi=on
dtparam=audio=on
gpu_mem=256

#dtparam=i2c_arm=on
#dtparam=i2c1=on
#dtparam=i2c1_baudrate=50000
#dtoverlay=i2c-rtc,ds3231
```
