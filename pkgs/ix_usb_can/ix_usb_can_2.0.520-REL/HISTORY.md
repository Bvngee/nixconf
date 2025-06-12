# ix_usb_can

## History

### 2.0.520	(2024-06-04)

- Call can_put_echo_skb() on current skb after encoding the can message. It seems that calling it before
  sometimes messed up the skb and led to a kernel NULL pointer dereference bug when dereferencing 
  skb->data inside ixxat_usb_encode_msg(). This had been seen on different kernel versions (5.x, 6.x) 
  happened very sporadic within a very large time frame of 15 minutes up to 5.5 days. 
- kernel >= 6.1.0: use can_dev_dropped_skb() instead of can_dropped_invalid_skb() to check skb in ixxat_usb_start_xmit()
- remove call to usb_reset_configuration() in probe because it leads to VMWare to crash later during device usage.
  It seems hat VMWare selects the wrong usb configuration after the reset.
- replace kfree_skb() with dev_kfree_skb() calls

### 2.0.504	(2024-04-15)

- accept command responses with less than the requested size (e.g. USB2CAN V2 FW versions < 1.6.3.0 do not send reserved parts of some response packets)
  but check firmware responses to have at least response header size (12 bytes)
- fix driver access to USB2CAN (fd) devices with firmware 1.0.1 (avoid exec unknown IXXAT_USB_BRD_CMD_GET_FWINFO2 command on CL1 firmware)

### 2.0.492	(2024-04-02)

- cleanup error messages
- USB devices: read firmware version and support sysfs attributes (serial, firmware_version, hardware, hardware_version, fpga_version)
- USB driver: replace unregister_netdev() with unregister_candev() call
- USB driver: read device info only once per device, not during controller init
- disable all trace_printk in release version
- set device address from hardware ID, init dev_id and dev_port to controller index
- add rsvd attributes to ixxat_usb_caps_cmd and ixxat_usb_info_cmd to fix struct sizes (to a multiple of sizeof(DWORD))

### 2.0.456	(2024-02-29)

- fix message reception not working with USB2CAN V2 and firmware version 1.6.3 (ICBT-223)

### 2.0.455	(2024-02-27)

- fix build against kernel version 5.12
- cleanup kernel version dependent code
- replace calls to netif_napi_add() with netif_napi_add_weight()
- handle different signatures of skb and dlc functions depending on kernel version
- solves a problem in message xmit
  The skb could be accessed after a free_skb call, this results in a incorrect behavior

### 2.0.366	(2020-03-12)

- initial version

## Known issues:

### Incompatibility with older firmware versions

Version 2.0.492 introduced more restrictive checking of firmware response packages which caused the driver to not work with
older firmware versions.

Updating the driver to 2.0.504 or higher or updating the firmware to at least 1.6.3.x (USB-to-CAN V2) or 1.7.0.x (USB-to-CAN fd)  resolves this.

### Dropped messages on kernel 4.15 to 4.17 (resolved in kernel 5.4.0)

We observed sporadic dropped messages on Ubuntu 18.04 LTS. According to the current knowledge this is not a driver issue but a problem within the
SocketCAN implementation in the specific kernel version. The problem has been observed with a self compiled kernel 4.17.0 on Ubuntu 18.04.01 LTS 
and Ubuntu 16.04.05 LTS even with other CAN devices (Peak USB).

The issue can be provoked with the follwing commands:

    sudo ip link set can0 up type can bitrate 1000000
    sudo ip link set txqueuelen 10 dev can0
    cangen -g 0 -Ii -L8 -Di -n 1000 -i -x can0

If you check the interfaces with

    ip link

you see "qdisc fq_codel" which is an invalid setting for CAN networks:

    3: can0: <NOARP,ECHO> mtu 16 qdisc fq_codel state DOWN mode DEFAULT group default qlen 10 link/can

Changing this to a working value (pfifo_fast), must be done for every CAN:

    sudo tc qdisc replace dev can0 root pfifo_fast

More information on this issue can be found here:

https://github.com/systemd/systemd/issues/9194

According to that source the problem has been with a patch which then had been integrated into kernel 5.4-rc6.
Possible solution for this issue, use either

* sudo tc qdisc replace dev can0 root pfifo_fast
* check/patch config files in /etc/sysctl.d
* or upgrade kernel to version >= 5.4

### Segmentation fault occurs if used within VMWare Workstation

There had been segmentation faults observed if used with VMWare Workstation 15.5.7 on a Windows Host and Ubuntu 16.04 as the guest OS.
Currently there is no solution for this issue.

### CAN message reception errors with Ixxat USB-to-CAN V2 and firmware version 1.6.3

There are possible CAN message reception errors with Ixxat USB-to-CAN V2 and firmware version 1.6.3.
A firmware upgrade resolves this.
