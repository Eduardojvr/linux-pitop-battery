#! /bin/bash
# It would be nice if pt-battery-fw-update was documented...

# Check root
if [ $EUID != 0 ]; then
  echo 'Run as root.'
  exit 1
fi

# Unregister the battery for i2c access
echo 0x0b > /sys/class/i2c-adapter/i2c-1/delete_device

# This is required
modprobe i2c-dev

passes=100

while [ $passes -gt 0 ]; do
  until ./pt-battery-fw-update -d
  do
    echo '=== FAIL ============================================================='
  done
  echo '=== SUCCESS =========================================================='
  let passes--
  echo "$passes remaining"
done

echo 'Reboot before it breaks again!'
