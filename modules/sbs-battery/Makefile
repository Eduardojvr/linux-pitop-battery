obj-m += sbs-battery.o

KERNELRELEASE ?= $(shell uname -r)

KDIR ?= "/lib/modules/$(KERNELRELEASE)/build"

all:
	make -C "$(KDIR)" "M=$(PWD)" modules

clean:
	make -C "$(KDIR)" "M=$(PWD)" clean
