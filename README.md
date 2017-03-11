## Installing

 - Run `sudo apt-get install raspberrypi-kernel-headers`
 - Add `deb http://0xc9.net/apt-deb ./` to `/etc/apt/sources.list`
 - Run `sudo apt-get update`
 - Run `sudo apt-get install pitop-battery-support`

## Manual install method

This way uses `dpkg` instead of `apt`, which means you need to install
the dependencies yourself.

 - Run `sudo apt-get install raspberrypi-kernel-headers dkms`
 - If you want to check whether the proper kernel headers have been installed, see
   [check kernel header version](https://www.raspberrypi.org/forums/viewtopic.php?f=66&t=176897)
 - Grab all the .deb files on the
   [release page](https://github.com/bcnjr5/linux-pitop-battery/releases)
   for the latest version.
 - Use `dpkg` to install `i2c-gpio-param-dkms_1.0_all.deb` and
   `sbs-battery-dkms_1.0_all.deb`
   * `sudo dpkg -i i2c-gpio-param-dkms_1.0_all.deb sbs-battery-dkms_1.0_all.deb`
 - Use `dpkg` to instal

## Getting it working

After doing the above, you need to modify the following two files:

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

### `/boot/config.txt`

Remove anything that might load the i2c1 driver.

Here is my file:

```
dtparam=spi=on
dtparam=audio=on
gpu_mem=256

# All these are commented out:
#dtparam=i2c_arm=on
#dtparam=i2c1=on
#dtparam=i2c1_baudrate=50000
#dtoverlay=i2c-rtc,ds3231
```

### `install battery display in standard Raspbian desktop (lxde)`

- Right-click on menu bar and select `Add / Remove Panel Items`
- Click on the `Add` button, select `Battery Monitor` and click `Ok`
- Use the `Up` and `Down` buttons to position the `Battery Monitor` as you like
- Click the `Ok` button
- Right-click on the battery icon displayed
- Set Alarmtime to 20, to be on the safe side for the pi-top battery

This will give you a warning on the lxde desktop, if the rpi is o battery power
and only 20 minutes are left.

Install uPower Power manager. With the proposed settings, it will shutdown the rpi when it is on
battery power and only 720 seconds are left, unfortunately without any further warning on the lxde desktop

- In a terminal window, type `sudo apt-get install upower`
- Edit `/etc/UPower/UPower.conf`:
- Set `Igorelid` to `true`
- Set `TimeLow` to `1200`
- Set `TimeCritical` to `1200`
- Set `TimeAction` to `720`
- Set `CriticalPowerAction` to `PowerOff`
- Save new settings and reboot


## Other I2C hardware

Here are some examples for adding other I2C devices without using
device trees.

### Chronodot 2.1 Real Time Clock

I have an RTC connected to the hub, so I added this to `/etc/rc.local`:

```sh
# register the RTC (chronodot v2.1 connected to the Pi-Top Hub)
modprobe rtc-ds1307
echo ds3231 0x68 > /sys/class/i2c-adapter/i2c-1/new_device
```

### Pi-Top Speaker

If the Pi-Top speaker has worked before switching to the bit-banging
I2C driver, it should continue to work after the switch.
