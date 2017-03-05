#! /bin/bash

pushd modules/sbs-battery
make
popd
cp modules/sbs-battery/sbs-battery.ko .


if [ ! -a modules/i2c-gpio-param/Makefile ]; then
  git submodule init
  git submodule update
fi

pushd modules/i2c-gpio-param
make
popd
cp modules/i2c-gpio-param/i2c-gpio-param.ko .
