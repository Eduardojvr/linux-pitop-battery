obj-m += sbs-battery.o

KDIR := "/lib/modules/$(KERNEL_VERSION)/build"

all:
	make -C "$(KDIR)" "M=$(PWD)" modules

clean:
	make -C "$(KDIR)" "M=$(PWD)" clean
