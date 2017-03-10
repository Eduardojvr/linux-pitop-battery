#!/bin/sh

echo /lib/modules/*/build |
sed -e 's/ /\n/g' -e 's:/lib/modules/::g' -e 's:/build::g'
