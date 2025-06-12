mod-name += ix_usb_can
KERNEL_SRC          ?= /lib/modules/$(shell uname -r)/build
MOD_DIR             ?= kernel/drivers/net/can/usb/ixxat_usb
SRC_DIR             ?= $(shell pwd)/$(MOD_DIR)
DEST_DIR            ?= /lib/modules/$(shell uname -r)/$(MOD_DIR)

#
# the Kernel Makefile is used !
#

.PHONY: all clean modules_install install uninstall

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC_DIR) CONFIG_CAN_IXXAT_USB=m modules

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC_DIR) CONFIG_CAN_IXXAT_USB=m clean

modules_install:
	$(MAKE) -C "$(KERNEL_SRC)" M=$(SRC_DIR) CONFIG_CAN_IXXAT_USB=m modules_install

install: all
	install -d "$(DEST_DIR)"
	install "$(SRC_DIR)/$(mod-name).ko" "$(DEST_DIR)"
	depmod -a
	modprobe $(mod-name)

uninstall:
	modprobe -r $(mod-name)
	depmod -a
	rm -f "$(DEST_DIR)/$(mod-name).ko"
