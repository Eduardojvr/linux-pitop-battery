#! /bin/bash
# It would be nice if pt-battery-fw-update was documented...

# Check root
if [ $EUID != 0 ]; then
  echo 'Run as root.'
  exit 1
fi

# Unregister the battery for i2c access
if [ -a /sys/class/i2c-adapter/i2c-1/1-000b ]; then
  echo 0x0b > /sys/class/i2c-adapter/i2c-1/delete_device
fi

# This is required by pt-battery-fw-update
modprobe i2c-dev

until ./pt-battery-fw-update -d
do
  echo '=== FAIL ============================================================='
done
echo '=== SUCCESS =========================================================='
