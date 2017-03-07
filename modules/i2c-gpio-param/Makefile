obj-m := i2c-gpio-param.o

KDIR := "/lib/modules/$(KERNEL_VERSION)/build"

PWD := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
