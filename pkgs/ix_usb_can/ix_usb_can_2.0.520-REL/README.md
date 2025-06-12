# IXXAT USB-to-CAN Driver

The IXXAT USB-To-CAN linux driver provides support for the following devices:

* IXXAT USB-to-CAN V2 compact
* IXXAT USB-to-CAN V2 embedded
* IXXAT USB-to-CAN V2 professional
* IXXAT USB-to-CAN V2 automotive
* IXXAT USB-to-CAN V2 plugin
* IXXAT USB-to-CAN FD compact
* IXXAT USB-to-CAN FD professional
* IXXAT USB-to-CAN FD automotive
* IXXAT USB-to-CAN FD MiniPCIe
* IXXAT USB-to-CAR
* IXXAT CAN-IDM101

## Install

The installation of the linux driver requires that the linux kernel header files
and the necessary build tools are installed on your system. You can install them as follows:

Debian based systems:

```
$ sudo apt install linux-headers-$(uname -r)
$ sudo apt install --reinstall build-essential
```

Raspbian:
```
$ sudo apt-get install raspberrypi-kernel-headers
```

Fedora and Red Hat:

```
$ su -
# yum -y install kernel-devel kernel-headers
# yum -y groupinstall 'Development Tools'
```





You can check if the headers are installed by running the following command:

```
$ ls /usr/src/linux-headers-$(uname -r)
```

Compile the kernel module by running make:

```
$ make all
```

You can then install the module by running:

Debian based systems:

```
$ sudo make install
```

Fedora and Red Hat:

```
$ su -
# make install
```

This will build your modules, install them in a shared directory and load
them into the kernel.

Congratulations! You can now use the IXXAT USB-to-CAN devices.
