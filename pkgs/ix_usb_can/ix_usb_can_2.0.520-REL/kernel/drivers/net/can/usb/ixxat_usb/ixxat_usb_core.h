/* SPDX-License-Identifier: GPL-2.0 */

/* CAN driver base for IXXAT USB-to-CAN
 *
 * Copyright (C) 2018 HMS Industrial Networks <socketcan@hms-networks.de>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published
 * by the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 */

#ifndef IXXAT_USB_CORE_H
#define IXXAT_USB_CORE_H

//#define IXXAT_USB_DRIVER_NAME  KBUILD_MODNAME  -> "ix_usb_can"
//#define IXXAT_USB_CTRL_NAME "ixxat_usb"

#define IXXAT_USB_VENDOR_ID 0x08d8

/* supported device ids: CL1 */
#define USB2CAN_COMPACT_PRODUCT_ID 0x0008
#define USB2CAN_EMBEDDED_PRODUCT_ID 0x0009
#define USB2CAN_PROFESSIONAL_PRODUCT_ID 0x000A
#define USB2CAN_AUTOMOTIVE_PRODUCT_ID 0x000B
#define USB2CAN_PLUGIN_PRODUCT_ID 0x001F

/* supported device ids: CL2 */
#define USB2CAN_FD_COMPACT_PRODUCT_ID 0x0014
#define USB2CAN_FD_PROFESSIONAL_PRODUCT_ID 0x0016
#define USB2CAN_FD_AUTOMOTIVE_PRODUCT_ID 0x0017
#define USB2CAN_FD_PCIE_MINI_PRODUCT_ID 0x001B
#define USB2CAR_PRODUCT_ID 0x001C
#define CAN_IDM101_PRODUCT_ID 0xFF12
#define CAN_IDM200_PRODUCT_ID 0xFF13

#define IXXAT_USB_BUS_CAN 1

#define IXXAT_USB_BUS_TYPE(type) ((u8)(((type) >> 8) & 0x00FF))

#define IXXAT_USB_STATE_CONNECTED BIT(0)
#define IXXAT_USB_STATE_STARTED BIT(1)

#define IXXAT_USB_FREE_ENTRY  0xFFFF

#define IXXAT_USB_MAX_CHANNEL 5
#define IXXAT_USB_MAX_TYPES 32
#define IXXAT_USB_MAX_RX_URBS 4
#define IXXAT_USB_MAX_TX_URBS 10
#define IXXAT_USB_MSG_IDX_OFFSET 0x10

#define IXXAT_USB_MAX_COM_REQ 10

#define IXXAT_USB_MAX_MSGS    32

#define IXXAT_USB_MSG_TIMEOUT 50
#define IXXAT_USB_MSG_CYCLE 20

#define IXXAT_USB_POWER_WAKEUP 0
#define IXXAT_USB_POWER_WAKEUP_TIME 500

#define IXXAT_USB_FWTYPE_RES		0	// reserved
#define IXXAT_USB_FWTYPE_FLD		1	// flash loader firmware
#define IXXAT_USB_DEV__CCL			2	// CCL conform firmware
#define IXXAT_USB_DEV_FWTYPE_BAL	3	// BAL conform firmware
#define IXXAT_USB_DEV_FWTYPE_BMG	4	// BMG conform firmware

#define IXXAT_USB_OPMODE_STANDARD BIT(0)
#define IXXAT_USB_OPMODE_EXTENDED BIT(1)
#define IXXAT_USB_OPMODE_ERRFRAME BIT(2)
#define IXXAT_USB_OPMODE_LISTONLY BIT(3)

#define IXXAT_USB_EXMODE_EXTDATA BIT(0)
#define IXXAT_USB_EXMODE_FASTDATA BIT(1)
#define IXXAT_USB_EXMODE_ISOFD BIT(2)

#define IXXAT_USB_BTMODE_NAT BIT(0)
#define IXXAT_USB_BTMODE_TSM BIT(1)

#define IXXAT_USB_STOP_ACTION_CLEARALL 3

#define IXXAT_RESTART_TASK_CYCLE_TIME 20

#define IXXAT_USB_CAN_DATA 0x00
#define IXXAT_USB_CAN_INFO 0x01
#define IXXAT_USB_CAN_ERROR 0x02
#define IXXAT_USB_CAN_STATUS 0x03
#define IXXAT_USB_CAN_WAKEUP 0x04
#define IXXAT_USB_CAN_TIMEOVR 0x05
#define IXXAT_USB_CAN_TIMERST 0x06

#define IXXAT_USB_CAN_STATUS_OK 0x00000000
#define IXXAT_USB_CAN_STATUS_OVERRUN 0x00000002
#define IXXAT_USB_CAN_STATUS_ERRLIM 0x00000004
#define IXXAT_USB_CAN_STATUS_BUSOFF 0x00000008
#define IXXAT_USB_CAN_STATUS_ERR_PAS 0x00002000

#define IXXAT_USB_CAN_ERROR_LEN 5

#define IXXAT_USB_CAN_ERROR_CODE 0
#define IXXAT_USB_CAN_ERROR_COUNTER_RX 3
#define IXXAT_USB_CAN_ERROR_COUNTER_TX 4

#define IXXAT_USB_CAN_ERROR_STUFF 1
#define IXXAT_USB_CAN_ERROR_FORM 2
#define IXXAT_USB_CAN_ERROR_ACK 3
#define IXXAT_USB_CAN_ERROR_BIT 4
#define IXXAT_USB_CAN_ERROR_CRC 6

#define IXXAT_USB_MSG_FLAGS_TYPE 0x000000FF
#define IXXAT_USB_MSG_FLAGS_DLC 0x000F0000
#define IXXAT_USB_MSG_FLAGS_OVR 0x00100000
#define IXXAT_USB_MSG_FLAGS_SRR 0x00200000
#define IXXAT_USB_MSG_FLAGS_RTR 0x00400000
#define IXXAT_USB_MSG_FLAGS_EXT 0x00800000

#define IXXAT_USB_DECODE_DLC(flags) (((flags) & IXXAT_USB_MSG_FLAGS_DLC) >> 16)
#define IXXAT_USB_ENCODE_DLC(len) (((len) << 16) & IXXAT_USB_MSG_FLAGS_DLC)

#define IXXAT_USB_FDMSG_FLAGS_EDL 0x00000400
#define IXXAT_USB_FDMSG_FLAGS_FDR 0x00000800
#define IXXAT_USB_FDMSG_FLAGS_ESI 0x00001000

#define IXXAT_USB_CAN_CMD_START 0x326
#define IXXAT_USB_CAN_CMD_STOP 0x327
#define IXXAT_USB_CAN_CMD_RESET 0x328

#define IXXAT_USB_BRD_CMD_GET_FWINFO	0x400
#define IXXAT_USB_BRD_CMD_GET_DEVCAPS	0x401
#define IXXAT_USB_BRD_CMD_GET_DEVINFO	0x402
#define IXXAT_USB_BRD_CMD_GET_FWINFO2	0x403
#define IXXAT_USB_BRD_CMD_POWER		0x421

#define IXXAT_USB_DEFAULT_RESTART_MS 100

#define IXXAT_USB_E_FAILED 0xFFFFFFFF

/**
 * struct ixxat_can_msg_base - IXXAT CAN message base (CL1/CL2)
 * @size: Message size (this field excluded)
 * @time: Message timestamp
 * @msg_id: Message ID
 * @flags: Message flags
 *
 * Contains the common fields of an IXXAT CAN message on both CL1 and CL2
 * devices
 */
struct ixxat_can_msg_base {
	u8 size;
	__le32 time;
	__le32 msg_id;
	__le32 flags;
} __packed;

/**
 * struct ixxat_can_msg_cl1 - IXXAT CAN message (CL1)
 * @data: Message data (standard CAN frame)
 *
 * Contains the fields of an IXXAT CAN message on CL1 devices
 */
struct ixxat_can_msg_cl1 {
	u8 data[CAN_MAX_DLEN];
} __packed;

/**
 * struct ixxat_can_msg_cl2 - IXXAT CAN message (CL2)
 * @client_id: Client ID
 * @data: Message data (CAN FD frame)
 *
 * Contains the fields of an IXXAT CAN message on CL2 devices
 */
struct ixxat_can_msg_cl2 {
	__le32 client_id;
	u8 data[CANFD_MAX_DLEN];
} __packed;

/**
 * struct ixxat_can_msg - IXXAT CAN message
 * @base: Base message
 * @cl1: Cl1 message
 * @cl2: Cl2 message
 *
 * Contains an IXXAT CAN message
 */
struct ixxat_can_msg {
	struct ixxat_can_msg_base base;
	union {
		struct ixxat_can_msg_cl1 cl1;
		struct ixxat_can_msg_cl2 cl2;
	};
} __packed;

/**
 * struct ixxat_dev_caps - Device capabilities
 * @bus_ctrl_count: Stores the bus controller counter
 * @bus_ctrl_types: Stores the bus controller types
 *
 * Contains the device capabilities
 */
struct ixxat_dev_caps {
	__le16 bus_ctrl_count;
	__le16 bus_ctrl_types[IXXAT_USB_MAX_TYPES];
} __packed;

/**
 * struct ixxat_canbtp Bittiming parameters (CL2)
 * @mode: Operation mode
 * @bps: Bits per second
 * @ts1: First time segment
 * @ts2: Second time segment
 * @sjw: Synchronization jump width
 * @tdo: Transmitter delay offset
 *
 * Bittiming parameters of a CL2 initialization request
 */
struct ixxat_canbtp {
	__le32 mode;
	__le32 bps;
	__le16 ts1;
	__le16 ts2;
	__le16 sjw;
	__le16 tdo;
} __packed;

/**
 * struct ixxat_dev_info IXXAT usb device information
 * @device_name: Name of the device
 * @device_id: Device identification ( unique device id)
 * @device_version: Device version ( 0, 1, ...)
 * @device_fpga_version: Version of FPGA design
 *
 * Contains device information of IXXAT USB devices
 */
struct ixxat_dev_info {
	char device_name[16];
	char device_id[16];
	__le16 device_version;
	__le32 device_fpga_version;
} __packed;

/**
 * struct ixxat_fw_info IXXAT usb firmware information
 * @firmware_type: type of currently running firmware
 * @major_version: major firmware version number
 * @minor_version: minor firmware version number
 * @build_version: build firmware version number
 *
 * Contains device information of IXXAT USB devices
 */

struct ixxat_fw_info {
	__le32 firmware_type;
	__le16 res;
	__le16 major_version;
	__le16 minor_version;
	__le16 build_version;
} __packed;

/**
 * struct ixxat_fw_info2 IXXAT usb firmware information
 * @firmware_type: type of currently running firmware
 * @major_version: major firmware version number
 * @minor_version: minor firmware version number
 * @build_version: build firmware version number
 * @revision     : revision number
 *
 * Contains device information of IXXAT USB devices
 */
struct ixxat_fw_info2 {
	__le32 firmware_type;
	__le16 res;
	__le16 major_version;
	__le16 minor_version;
	__le16 build_version;
	__le16 revision;
} __packed;

/**
 * struct ixxat_time_ref Time reference
 * @kt_host_0: Latest time on the host
 * @ts_dev_0: Latest time stamp on the device
 * @ts_dev_last: Last device time stamp
 *
 * Contains time references of the device and the host
 */
struct ixxat_time_ref {
	ktime_t kt_host_0;
	u32 ts_dev_0;
	u32 ts_dev_last;
};

/**
 * struct ixxat_tx_urb_context URB content for transmission
 * @dev: IXXAT USB device
 * @urb: USB request block
 * @urb_index: index of this URB (used to mark the context as occupied)
  * @msg_index: index of message ( client_id)
 * @msg_packet_len: Data length code (only used if no loopback is enabled)
 * @msg_packet_no: number of packets (only used if no loopback is enabled)
  *
 * Contains content for USB request block transmissions
 */
struct ixxat_tx_urb_context {
	struct ixxat_usb_device *dev;
	struct urb *urb;
	u16  urb_index;
	u16  msg_index;
	u16  msg_packet_no;
	u16  msg_packet_len;
};

/**
 * struct ixxat_usb_device IXXAT USB device
 * @can: CAN common private data
 * @adapter: USB network descriptor
 * @udev: USB device
 * @netdev: Net_device
 * @active_tx_urbs: Active tx urbs
 * @tx_anchor: Submitted tx usb anchor
 * @tx_contexts: Buffer for tx contexts
 * @rx_anchor: Submitted rx usb anchor
 * @msgs: store to set the used message indexes
 * @msg_lastindex: last index which was set
 * @msg_max: max possible number of messages to transmit
 * @loopback:  global loopback
 * @state: Device state
 * @ctrl_index: Controller index
 * @ep_msg_in: USB endpoint for incoming messages
 * @ep_msg_out: USB endpoint for outgoing messages
 * @prev_dev: Previous opened device
 * @next_dev: Next opened device in list
 * @time_ref: Time reference
 * @dev_info: Device information
 * @bec: CAN error counter
 *
 * IXXAT USB-to-CAN device
 */
struct ixxat_usb_device {
	struct can_priv can;
	const struct ixxat_usb_adapter *adapter;
	struct usb_device *udev;
	struct net_device *netdev;

	atomic_t active_tx_urbs;
	struct usb_anchor tx_anchor;
	struct ixxat_tx_urb_context tx_contexts[IXXAT_USB_MAX_TX_URBS];

	struct usb_anchor rx_anchor;
	void  *rx_buf[IXXAT_USB_MAX_RX_URBS];

	u32 msgs;
	u32 msg_lastindex;
	u32 msg_max;

	bool loopback;
	u32 state;
	u16 ctrl_index;
	u32 cnt_tx;

	u8 ep_msg_in;
	u8 ep_msg_out;

	/* This lock prevents a race condition between xmit and receive. */
	spinlock_t dev_lock;

	struct ixxat_usb_device *prev_dev;
	struct ixxat_usb_device *next_dev;

	struct ixxat_time_ref time_ref;
	struct ixxat_dev_info dev_info;
	struct ixxat_fw_info2 fw_info;

	struct can_berr_counter bec;
};

/**
 * struct ixxat_usb_dal_req IXXAT device request block
 * @size: Request size
 * @port: Request port
 * @socket: Request socket
 * @code: Request code
 *
 * IXXAT device request block
 */
struct ixxat_usb_dal_req {
	__le32 size;
	__le16 port;
	__le16 socket;
	__le32 code;
} __packed;

/**
 * struct ixxat_usb_dal_res IXXAT device response block
 * @res_size: Expected response size
 * @ret_size: Actual response size
 * @code: Return code
 *
 * IXXAT device response block
 */
struct ixxat_usb_dal_res {
	__le32 res_size;
	__le32 ret_size;
	__le32 code;
} __packed;

/**
 * struct ixxat_usb_dal_cmd IXXAT device command
 * @req: Request block
 * @req: Response block
 *
 * IXXAT device command
 */
struct ixxat_usb_dal_cmd {
	struct ixxat_usb_dal_req req;
	struct ixxat_usb_dal_res res;
} __packed;

/**
 * struct ixxat_usb_caps_cmd Device capabilities command
 * @req: Request block
 * @res: Response block
 * @caps: Device capabilities
 *
 * Can be sent to a device to request its capabilities
 */
struct ixxat_usb_caps_cmd {
	struct ixxat_usb_dal_req req;
	struct ixxat_usb_dal_res res;
	struct ixxat_dev_caps caps;
	__le16 rsvd;
} __packed;

/**
 * struct ixxat_usb_init_cl1_cmd Initialization command (CL1)
 * @req: Request block
 * @mode: Operation mode
 * @btr0: Bittiming register 0
 * @btr1: Bittiming register 1
 * @padding: 1 byte padding
 * @res: Response block
 *
 * Can be sent to a CL1 device to initialize it
 */
struct ixxat_usb_init_cl1_cmd {
	struct ixxat_usb_dal_req req;
	u8 mode;
	u8 btr0;
	u8 btr1;
	u8 padding;
	struct ixxat_usb_dal_res res;
} __packed;

/**
 * struct ixxat_usb_init_cl2_cmd Initialization command (CL2)
 * @req: Request block
 * @opmode: Operation mode
 * @exmode: Extended mode
 * @sdr: Stadard bittiming parameters
 * @fdr: Fast data bittiming parameters
 * @_padding: 2 bytes padding
 * @res: Response block
 *
 * Can be sent to a CL2 device to initialize it
 */
struct ixxat_usb_init_cl2_cmd {
	struct ixxat_usb_dal_req req;
	u8 opmode;
	u8 exmode;
	struct ixxat_canbtp sdr;
	struct ixxat_canbtp fdr;
	__le16 _padding;
	struct ixxat_usb_dal_res res;
} __packed;

/**
 * struct ixxat_usb_start_cmd Controller start command
 * @req: Request block
 * @res: Response block
 * @time: Timestamp
 *
 * Can be sent to a device to start its controller
 */
struct ixxat_usb_start_cmd {
	struct ixxat_usb_dal_req req;
	struct ixxat_usb_dal_res res;
	__le32 time;
} __packed;

/**
 * struct ixxat_usb_stop_cmd Controller stop command
 * @req: Request block
 * @action: Stop action
 * @res: Response block
 *
 * Can be sent to a device to start its controller
 */
struct ixxat_usb_stop_cmd {
	struct ixxat_usb_dal_req req;
	__le32 action;
	struct ixxat_usb_dal_res res;
} __packed;

/**
 * struct ixxat_usb_power_cmd Power command
 * @req: Request block
 * @mode: Power mode
 * @_padding1: 1 byte padding
 * @_padding2: 2 byte padding
 * @res: Response block
 *
 * Can be sent to a device to set its power mode
 */
struct ixxat_usb_power_cmd {
	struct ixxat_usb_dal_req req;
	u8 mode;
	u8 _padding1;
	__le16 _padding2;
	struct ixxat_usb_dal_res res;
} __packed;

/**
 * struct ixxat_usb_info_cmd Device information command
 * @req: Request block
 * @res: Response block
 * @info: Device information
 *
 * Can be sent to a device to request its device information
 */
struct ixxat_usb_info_cmd {
	struct ixxat_usb_dal_req req;
	struct ixxat_usb_dal_res res;
	struct ixxat_dev_info info;
	__le16 rsvd;
} __packed;

/**
 * struct ixxat_usb_fwinfo_cmd Firmware information command
 * @req: Request block
 * @res: Response block
 * @info: Firmware information
 *
 * Can be sent to a device to request its firmware information
 */
struct ixxat_usb_fwinfo_cmd {
	struct ixxat_usb_dal_req req;
	struct ixxat_usb_dal_res res;
	struct ixxat_fw_info info;
} __packed;

/**
 * struct ixxat_usb_fwinfo2_cmd Firmware information command
 * @req: Request block
 * @res: Response block
 * @info: Firmware information
 *
 * Can be sent to a device to request its firmware information
 */
struct ixxat_usb_fwinfo2_cmd {
	struct ixxat_usb_dal_req req;
	struct ixxat_usb_dal_res res;
	struct ixxat_fw_info2 info;
} __packed;

/**
 * struct ixxat_usb_adapter IXXAT USB device adapter
 * @clock: Clock frequency
 * @bt: Bittiming constants
 * @btd: Data bittiming constants
 * @modes: Supported modes
 * @buffer_size_rx: Buffer size for receiving
 * @buffer_size_tx: Buffer size for transfer
 * @ep_msg_in: USB endpoint buffer for incoming messages
 * @ep_msg_out: USB endpoint buffer for outgoing messages
 * @ep_offs: Endpoint offset (device depended)
 *
 * Device Adapter for IXXAT USB devices
 */
struct ixxat_usb_adapter {
	u32 modes;
	const u32 clock;
	const struct can_bittiming_const *bt;
	const struct can_bittiming_const *btd;
	const u16 buffer_size_rx;
	const u16 buffer_size_tx;
	const u8 ep_msg_in[IXXAT_USB_MAX_CHANNEL];
	const u8 ep_msg_out[IXXAT_USB_MAX_CHANNEL];
	const u8 ep_offs;
	int (*init_ctrl)(struct ixxat_usb_device *dev);
};

extern const struct ixxat_usb_adapter usb2can_cl1;
extern const struct ixxat_usb_adapter usb2can_v2;
extern const struct ixxat_usb_adapter usb2can_fd;
extern const struct ixxat_usb_adapter can_fd_idm;

/**
 * ixxat_usb_setup_cmd() - Setup a device command
 * @req: Request block
 * @res: Response block
 *
 * This function sets the default values in the request and the response block
 * of a device command
 */
void ixxat_usb_setup_cmd(struct ixxat_usb_dal_req *req,
			 struct ixxat_usb_dal_res *res);

/**
 * ixxat_usb_send_cmd() - Send a command to the device
 * @dev: USB device
 * @port: Command port
 * @req: Command request buffer
 * @req_size: Command request size
 * @res: Command response buffer
 * @res_size: Command response size
 *
 * This function sends a specific command to the device
 *
 * Return: Negative error code or zero on success
 */
int ixxat_usb_send_cmd(struct usb_device *dev, const u16 port, void *req,
		       const u16 req_size, void *res, const u16 res_size);

#endif /* IXXAT_USB_CORE_H */
