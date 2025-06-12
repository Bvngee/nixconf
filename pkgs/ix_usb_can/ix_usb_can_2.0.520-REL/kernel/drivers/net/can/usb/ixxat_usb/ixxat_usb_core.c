// SPDX-License-Identifier: GPL-2.0

/* CAN driver for IXXAT USB-to-CAN
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

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/can/dev.h>
#include <linux/kthread.h>
#include <linux/usb.h>
#include <linux/version.h>

#include "ixxat_usb_core.h"

#include "ixxat_kernel_adapt.h"

MODULE_AUTHOR("HMS Technology Center Ravensburg Gmbh <socketcan@hms-networks.de>");
MODULE_DESCRIPTION("SocketCAN driver for HMS Ixxat USB-to-CAN V2, USB-to-CAN-FD family adapters");
MODULE_LICENSE("GPL v2");
MODULE_VERSION("2.0.520-REL");

#define IX_STATISTICS_EXACT		0

/* minimum firmware version that supports V2 communication layer */
#define IX_MIN_MAJORFWVERSION_SUPP_V2	0x01
#define IX_MIN_MINORFWVERSION_SUPP_V2	0x07
#define IX_MIN_BUILDFWVERSION_SUPP_V2	0x00

#define IX_MINIMUM_CL2_FWVERSION(fwinfo) ( (le16_to_cpu((fwinfo).major_version) >= IX_MIN_MAJORFWVERSION_SUPP_V2) && \
				 (le16_to_cpu((fwinfo).minor_version) >= IX_MIN_MINORFWVERSION_SUPP_V2) && \
				 (le16_to_cpu((fwinfo).build_version) >= IX_MIN_BUILDFWVERSION_SUPP_V2))

/* Prefix for debug output - makes for easier grepping */
#define IX_DRIVER_TAG "ix_usb_can: "


#if defined(CONFIG_TRACING) && defined(DEBUG)
	#define ix_trace_printk(...) trace_printk(__VA_ARGS__)
#else
	#define ix_trace_printk(...)
#endif


/* Table of devices that work with this driver */
static const struct usb_device_id ixxat_usb_table[] = {
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, USB2CAN_COMPACT_PRODUCT_ID) },
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, USB2CAN_EMBEDDED_PRODUCT_ID) },
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, USB2CAN_PROFESSIONAL_PRODUCT_ID) },
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, USB2CAN_AUTOMOTIVE_PRODUCT_ID) },
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, USB2CAN_PLUGIN_PRODUCT_ID) },
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, USB2CAN_FD_COMPACT_PRODUCT_ID) },
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, USB2CAN_FD_PROFESSIONAL_PRODUCT_ID) },
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, USB2CAN_FD_AUTOMOTIVE_PRODUCT_ID) },
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, USB2CAN_FD_PCIE_MINI_PRODUCT_ID) },
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, USB2CAR_PRODUCT_ID) },
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, CAN_IDM101_PRODUCT_ID) },
	{ USB_DEVICE(IXXAT_USB_VENDOR_ID, CAN_IDM200_PRODUCT_ID) },
	{ } /* Terminating entry */
};

MODULE_DEVICE_TABLE(usb, ixxat_usb_table);


#ifdef DEBUG
	static void showdevcaps(struct ixxat_dev_caps dev_caps) {
		int i = 0;

		ix_trace_printk ("CtrlCount = %i \n", dev_caps.bus_ctrl_count);

		for ( i = 0; i < dev_caps.bus_ctrl_count; i++ ) {
			ix_trace_printk ("Type = %i \n", dev_caps.bus_ctrl_types[i]);
		}
	}

	static int showdump( u8 * pbdata, u16 length) {
		char caDump[100] = "Dump: ";
		char szBuf[10]="";
		int i =0;
		u16 len = (length > 25)? 25 : length;

		for ( i =0; i< len; i++)
		{
			sprintf (szBuf, "%02x ", pbdata[i]);
			strcat (caDump, szBuf);
		}
		strcat (caDump, "\n");

		ix_trace_printk ( caDump );
		return 0;
	}
#endif

static struct ixxat_tx_urb_context *ixxat_usb_get_tx_context(struct ixxat_usb_device *dev)
{
	struct ixxat_tx_urb_context *context = NULL;
	u32 UrbIdx = 0;
	unsigned long flags;

	spin_lock_irqsave(&dev->dev_lock, flags);

	// find free URB
	for (UrbIdx = 0; UrbIdx < IXXAT_USB_MAX_TX_URBS; UrbIdx++) {
		// is urb allocated
		if (dev->tx_contexts[UrbIdx].urb) {
			// is urb free
			if (dev->tx_contexts[UrbIdx].urb_index == IXXAT_USB_FREE_ENTRY) {
				context = &dev->tx_contexts[UrbIdx];
				context->urb_index = UrbIdx;
				break;
			}
		}
	}

	spin_unlock_irqrestore(&dev->dev_lock, flags);

	return context;
}

static void ixxat_usb_rel_tx_context(struct ixxat_usb_device *dev,
		struct ixxat_tx_urb_context *context)
{
	unsigned long flags;
	spin_lock_irqsave(&dev->dev_lock, flags);

	if (context)
		context->urb_index = IXXAT_USB_FREE_ENTRY;

	spin_unlock_irqrestore(&dev->dev_lock, flags);
}

static u32 ixxat_usb_msg_get_next_idx(struct ixxat_usb_device *dev)
{
	u32 ret;
	unsigned long flags;

	u32 MsgIdx = 0;
	u32 LoopCnt = 0;
	u64 Mask;

	spin_lock_irqsave(&dev->dev_lock, flags);

	// can.echo_skb_max
	MsgIdx = (dev->msg_lastindex + 1) % dev->msg_max;
	while (LoopCnt < dev->msg_max) {
		Mask = (1 << MsgIdx);

		if (0 == (dev->msgs & Mask)) {
			dev->msgs |= Mask;
		break;
		}

		MsgIdx = (MsgIdx + 1) % dev->msg_max;
		LoopCnt++;
	}

	if (LoopCnt < dev->msg_max) {
		dev->msg_lastindex = MsgIdx;
		ret = MsgIdx;
	} else
		ret = IXXAT_USB_E_FAILED;

	spin_unlock_irqrestore(&dev->dev_lock, flags);

	return ret;
}

static void ixxat_usb_msg_free_idx(struct ixxat_usb_device *dev, u32 MsgIdx)
{
	unsigned long flags;
	u64 Mask;

	spin_lock_irqsave(&dev->dev_lock, flags);

	if (MsgIdx == 0xFFFFFFFF) {
		dev->msgs = 0;
		dev->msg_lastindex = 0;
	} else {
		if (MsgIdx < dev->msg_max) {
			Mask = (1 << MsgIdx);
			dev->msgs &= ~Mask;
		}
	}

	spin_unlock_irqrestore(&dev->dev_lock, flags);
}

void ixxat_usb_setup_cmd(struct ixxat_usb_dal_req *req,
			 struct ixxat_usb_dal_res *res)
{
	req->size = cpu_to_le32(sizeof(*req));
	req->port = cpu_to_le16(0xffff);
	req->socket = cpu_to_le16(0xffff);
	req->code = cpu_to_le32(0);

	res->res_size = cpu_to_le32(sizeof(*res));
	res->ret_size = cpu_to_le32(0);
	res->code = cpu_to_le32(0xffffffff);
}

int ixxat_usb_send_cmd(struct usb_device *dev, const u16 port, void *req,
		       const u16 req_size, void *res, const u16 res_size)
{
	const int to = msecs_to_jiffies(IXXAT_USB_MSG_TIMEOUT);
	const u8 rq = 0xff;
	const u8 rti = USB_TYPE_VENDOR | USB_DIR_IN;
	const u8 rto = USB_TYPE_VENDOR | USB_DIR_OUT;
	int i;
	int pos = 0;
	int rcp = usb_rcvctrlpipe(dev, 0);
	int scp = usb_sndctrlpipe(dev, 0);
	int ret = 0;
	struct ixxat_usb_dal_res *dal_res = res;

	for (i = 0; i < IXXAT_USB_MAX_COM_REQ; ++i) {
		ret = usb_control_msg(dev, scp, rq, rto, port, 0, req, req_size, to);
		if (ret < 0)
			msleep(IXXAT_USB_MSG_CYCLE);
		else
			break;
	}

	if (ret < 0) {
		dev_err(&dev->dev, "Error %d: TX command failure\n", ret);
		goto fail;
	}

	for (i = 0; i < IXXAT_USB_MAX_COM_REQ; ++i) {
		const int rs = res_size - pos;
		void *rb = res + pos;

		ret = usb_control_msg(dev, rcp, rq, rti, port, 0, rb, rs, to);
		if (ret < 0) {
			msleep(IXXAT_USB_MSG_CYCLE);
			continue;
		}

		pos += ret;
		if (pos < res_size)
			msleep(IXXAT_USB_MSG_CYCLE);
		else
			break;
	}

	// firmware responses may be smaller then requested response size
	// but should be not smaller than the response header size
	if (pos < sizeof(struct ixxat_usb_dal_res))
	{
		dev_err(&dev->dev, "Command answer size failure: got %u expected %u\n", pos, res_size);
		ret = -EBADMSG;
	}

	if (ret < 0) {
		dev_err(&dev->dev, "Error %d: RX command failure\n", ret);
		goto fail;
	}

	ret = le32_to_cpu(dal_res->code);

fail:
	return ret;
}

static void ixxat_usb_update_ts_now(struct ixxat_usb_device *dev, u32 ts_now)
{
	u32 *ts_dev = &dev->time_ref.ts_dev_0;
	ktime_t *kt_host = &dev->time_ref.kt_host_0;
	u64 timebase = (u64)0x00000000FFFFFFFF - (u64)(*ts_dev) + (u64)ts_now;

	*kt_host = ktime_add_us(*kt_host, timebase);
	*ts_dev = ts_now;
}

static void ixxat_usb_get_ts_tv(struct ixxat_usb_device *dev, u32 ts,
				ktime_t *k_time)
{
	ktime_t tmp_time = dev->time_ref.kt_host_0;

	if (ts < dev->time_ref.ts_dev_last)
		ixxat_usb_update_ts_now(dev, ts);

	dev->time_ref.ts_dev_last = ts;
	tmp_time = ktime_add_us(tmp_time, ts - dev->time_ref.ts_dev_0);

	if (k_time)
		*k_time = tmp_time;
}

static void ixxat_usb_set_ts_now(struct ixxat_usb_device *dev, u32 ts_now)
{
	dev->time_ref.ts_dev_0 = ts_now;
	dev->time_ref.kt_host_0 = ktime_get_real();
	dev->time_ref.ts_dev_last = ts_now;
}

static int ixxat_usb_get_dev_caps(struct usb_device *dev,
				  struct ixxat_dev_caps *dev_caps)
{
	int i;
	int err;
	struct ixxat_usb_caps_cmd *cmd;
	const u32 cmd_size = sizeof(*cmd);
	const u32 req_size = sizeof(cmd->req);
	const u32 rcv_size = cmd_size - req_size;
	const u32 snd_size = req_size + sizeof(cmd->res);
	u16 num_ctrl;

	cmd = kmalloc(cmd_size, GFP_KERNEL);
	if (!cmd)
		return -ENOMEM;

	ixxat_usb_setup_cmd(&cmd->req, &cmd->res);
	cmd->req.code = cpu_to_le32(IXXAT_USB_BRD_CMD_GET_DEVCAPS);
	cmd->res.res_size = cpu_to_le32(rcv_size);

	err = ixxat_usb_send_cmd(dev, le16_to_cpu(cmd->req.port), cmd, snd_size,
				 &cmd->res, rcv_size);
	if (err)
		goto fail;

	dev_caps->bus_ctrl_count = cmd->caps.bus_ctrl_count;
	num_ctrl = le16_to_cpu(dev_caps->bus_ctrl_count);
	if (num_ctrl > ARRAY_SIZE(dev_caps->bus_ctrl_types)) {
		err = -EINVAL;
		goto fail;
	}

	for (i = 0; i < num_ctrl; i++)
		dev_caps->bus_ctrl_types[i] = cmd->caps.bus_ctrl_types[i];

fail:
	kfree(cmd);
	return err;
}

static int ixxat_usb_get_dev_info(struct usb_device *dev,
				  struct ixxat_dev_info *dev_info)
{
	int err;
	struct ixxat_usb_info_cmd *cmd;
	const u32 cmd_size = sizeof(*cmd);
	const u32 req_size = sizeof(cmd->req);
	const u32 rcv_size = cmd_size - req_size;
	const u32 snd_size = req_size + sizeof(cmd->res);

	cmd = kmalloc(cmd_size, GFP_KERNEL);
	if (!cmd)
		return -ENOMEM;

	ixxat_usb_setup_cmd(&cmd->req, &cmd->res);
	cmd->req.code = cpu_to_le32(IXXAT_USB_BRD_CMD_GET_DEVINFO);
	cmd->res.res_size = cpu_to_le32(rcv_size);

	err = ixxat_usb_send_cmd(dev, le16_to_cpu(cmd->req.port), cmd, snd_size, &cmd->res, rcv_size);
	if (err)
		goto fail;

	if (dev_info) {
		memcpy(dev_info->device_id, &cmd->info.device_id,
		       sizeof(cmd->info.device_id));
		memcpy(dev_info->device_name, &cmd->info.device_name,
		       sizeof(cmd->info.device_name));
		dev_info->device_fpga_version = cmd->info.device_fpga_version;
		dev_info->device_version = cmd->info.device_version;
	}

fail:
	kfree(cmd);

	return err;
}

static int ixxat_usb_get_fw_info(struct usb_device *dev,
				  struct ixxat_fw_info2 *dev_info)
{
	int err;
	struct ixxat_usb_fwinfo_cmd *cmd;
	const u32 cmd_size = sizeof(*cmd);
	const u32 req_size = sizeof(cmd->req);
	const u32 rcv_size = cmd_size - req_size;
	const u32 snd_size = req_size + sizeof(cmd->res);

	cmd = kmalloc(cmd_size, GFP_KERNEL);
	if (!cmd)
		return -ENOMEM;

	ixxat_usb_setup_cmd(&cmd->req, &cmd->res);
	cmd->req.code = cpu_to_le32(IXXAT_USB_BRD_CMD_GET_FWINFO);
	cmd->res.res_size = cpu_to_le32(rcv_size);

	err = ixxat_usb_send_cmd(dev, le16_to_cpu(cmd->req.port), cmd, snd_size,
				 &cmd->res, rcv_size);
	if (err)
		goto fail;

	if (dev_info) {
		dev_info->firmware_type = cmd->info.firmware_type;
		dev_info->major_version = cmd->info.major_version;
		dev_info->minor_version = cmd->info.minor_version;
		dev_info->build_version = cmd->info.build_version;
		dev_info->revision = 0;
	}

fail:
	kfree(cmd);

	return err;
}

static int ixxat_usb_get_fw_info2(struct usb_device *dev,
				  struct ixxat_fw_info2 *dev_info)
{
	int err;
	struct ixxat_usb_fwinfo2_cmd *cmd;
	const u32 cmd_size = sizeof(*cmd);
	const u32 req_size = sizeof(cmd->req);
	const u32 rcv_size = cmd_size - req_size;
	const u32 snd_size = req_size + sizeof(cmd->res);

	cmd = kmalloc(cmd_size, GFP_KERNEL);
	if (!cmd)
		return -ENOMEM;

	ixxat_usb_setup_cmd(&cmd->req, &cmd->res);
	cmd->req.code = cpu_to_le32(IXXAT_USB_BRD_CMD_GET_FWINFO2);
	cmd->res.res_size = cpu_to_le32(rcv_size);

	err = ixxat_usb_send_cmd(dev, le16_to_cpu(cmd->req.port), cmd, snd_size,
				 &cmd->res, rcv_size);
	if (err)
		goto fail;

	if (dev_info) {
		dev_info->firmware_type = cmd->info.firmware_type;
		dev_info->major_version = cmd->info.major_version;
		dev_info->minor_version = cmd->info.minor_version;
		dev_info->build_version = cmd->info.build_version;
		dev_info->revision = cmd->info.revision;
	}

fail:
	kfree(cmd);

	return err;
}

static int ixxat_usb_start_ctrl(struct ixxat_usb_device *dev, u32 *time_ref)
{
	const u16 port = dev->ctrl_index;
	int err;
	struct ixxat_usb_start_cmd *cmd;
	const u32 cmd_size = sizeof(*cmd);
	const u32 req_size = sizeof(cmd->req);
	const u32 rcv_size = cmd_size - req_size;
	const u32 snd_size = req_size + sizeof(cmd->res);

	cmd = kmalloc(cmd_size, GFP_KERNEL);
	if (!cmd)
		return -ENOMEM;

	ixxat_usb_setup_cmd(&cmd->req, &cmd->res);
	cmd->req.code = cpu_to_le32(IXXAT_USB_CAN_CMD_START);
	cmd->req.port = cpu_to_le16(port);
	cmd->res.res_size = cpu_to_le32(rcv_size);
	cmd->time = 0;

	err = ixxat_usb_send_cmd(dev->udev, port, cmd, snd_size, &cmd->res,
				 rcv_size);
	if (err)
		goto fail;

	if (time_ref)
		*time_ref = le32_to_cpu(cmd->time);

fail:
	kfree(cmd);

	return err;
}

static int ixxat_usb_stop_ctrl(struct ixxat_usb_device *dev)
{
	const u16 port = dev->ctrl_index;
	int err;
	struct ixxat_usb_stop_cmd *cmd;
	const u32 rcv_size = sizeof(cmd->res);
	const u32 snd_size = sizeof(*cmd);

	cmd = kmalloc(snd_size, GFP_KERNEL);
	if (!cmd)
		return -ENOMEM;

	ixxat_usb_setup_cmd(&cmd->req, &cmd->res);
	cmd->req.size = cpu_to_le32(snd_size - rcv_size);
	cmd->req.code = cpu_to_le32(IXXAT_USB_CAN_CMD_STOP);
	cmd->req.port = cpu_to_le16(port);
	cmd->action = cpu_to_le32(IXXAT_USB_STOP_ACTION_CLEARALL);

	err = ixxat_usb_send_cmd(dev->udev, port, cmd, snd_size, &cmd->res,
				 rcv_size);

	kfree(cmd);

	return err;
}

static int ixxat_usb_power_ctrl(struct usb_device *dev, u8 mode)
{
	int err;
	struct ixxat_usb_power_cmd *cmd;
	const u32 rcv_size = sizeof(cmd->res);
	const u32 snd_size = sizeof(*cmd);

	cmd = kmalloc(snd_size, GFP_KERNEL);
	if (!cmd)
		return -ENOMEM;

	ixxat_usb_setup_cmd(&cmd->req, &cmd->res);
	cmd->req.size = cpu_to_le32(snd_size - rcv_size);
	cmd->req.code = cpu_to_le32(IXXAT_USB_BRD_CMD_POWER);
	cmd->mode = mode;

	err = ixxat_usb_send_cmd(dev, le16_to_cpu(cmd->req.port), cmd, snd_size,
				 &cmd->res, rcv_size);
	kfree(cmd);

	return err;
}

static int ixxat_usb_reset_ctrl(struct ixxat_usb_device *dev)
{
	const u16 port = dev->ctrl_index;
	int err;
	struct ixxat_usb_dal_cmd *cmd;
	const u32 snd_size = sizeof(*cmd);
	const u32 rcv_size = sizeof(cmd->res);

	cmd = kmalloc(snd_size, GFP_KERNEL);
	if (!cmd)
		return -ENOMEM;

	ixxat_usb_setup_cmd(&cmd->req, &cmd->res);
	cmd->req.code = cpu_to_le32(IXXAT_USB_CAN_CMD_RESET);
	cmd->req.port = cpu_to_le16(port);

	err = ixxat_usb_send_cmd(dev->udev, port, cmd, snd_size, &cmd->res,
				 rcv_size);
	kfree(cmd);
	return err;
}

static void ixxat_usb_free_usb_communication(struct ixxat_usb_device *dev)
{
	struct net_device *netdev = dev->netdev;
	u32 SkbIdx;
	u32 UrbIdx;

	ix_trace_printk (">> ixxat_usb_free_usb_communication\n");

	netif_stop_queue(netdev);
	usb_kill_anchored_urbs(&dev->rx_anchor);
	usb_kill_anchored_urbs(&dev->tx_anchor);
	atomic_set(&dev->active_tx_urbs, 0);

	// reset msg idx store
	ixxat_usb_msg_free_idx(dev, 0xFFFFFFFF);

	for (SkbIdx = 0; SkbIdx < dev->can.echo_skb_max; SkbIdx++)
		can_free_echo_skb(netdev, SkbIdx, NULL);

	for (UrbIdx = 0; UrbIdx < IXXAT_USB_MAX_TX_URBS; UrbIdx++) {
		if (dev->tx_contexts[UrbIdx].urb_index != IXXAT_USB_FREE_ENTRY)
			dev->tx_contexts[UrbIdx].urb_index = IXXAT_USB_FREE_ENTRY;
	}

	ix_trace_printk ("<< ixxat_usb_free_usb_communication\n");

	// Annotation:
	//   The Urbs are released within the system with (usb_free_urb)
	//   dependant on the reference count
	//   With the Urbs the assigned buffers are also deleted.
	//   This is caused by urb->transfer_flags |= URB_FREE_BUFFER;
}

static int ixxat_usb_restart(struct ixxat_usb_device *dev)
{
	int err;
	struct net_device *netdev = dev->netdev;
	u32 t;

	err = ixxat_usb_stop_ctrl(dev);
	if (err)
		goto fail;

	err = ixxat_usb_start_ctrl(dev, &t);
	if (err)
		goto fail;

	dev->can.state = CAN_STATE_ERROR_ACTIVE;
	netif_wake_queue(netdev);

fail:
	return err;
}

static int ixxat_usb_set_mode(struct net_device *netdev, enum can_mode mode)
{
	int err;
	struct ixxat_usb_device *dev = netdev_priv(netdev);

	switch (mode) {
	case CAN_MODE_START:
		err = ixxat_usb_restart(dev);
		break;
	default:
		err = -EOPNOTSUPP;
		break;
	}

	return err;
}

static int ixxat_usb_get_berr_counter(const struct net_device *netdev,
				      struct can_berr_counter *bec)
{
	struct ixxat_usb_device *dev = netdev_priv(netdev);

	*bec = dev->bec;
	return 0;
}

static void ixxat_convert(const struct ixxat_usb_adapter *pAdapter,
			struct canfd_frame *cf,
			struct ixxat_can_msg *rx,
			u8 datalen)
{
	const u32 ixx_flags = le32_to_cpu(rx->base.flags);
	u8 flags = 0;

	if (ixx_flags & IXXAT_USB_FDMSG_FLAGS_EDL) {
		if (ixx_flags & IXXAT_USB_FDMSG_FLAGS_FDR)
			flags |= CANFD_BRS;

		if (ixx_flags & IXXAT_USB_FDMSG_FLAGS_ESI)
			flags |= CANFD_ESI;
	}

	cf->can_id = le32_to_cpu(rx->base.msg_id);
	cf->len    = datalen;
	cf->flags  |= flags;

	if (ixx_flags & IXXAT_USB_MSG_FLAGS_EXT)
		cf->can_id |= CAN_EFF_FLAG;

	if (ixx_flags & IXXAT_USB_MSG_FLAGS_RTR) {
		cf->can_id |= CAN_RTR_FLAG;
	} else {
		if (pAdapter == &usb2can_cl1)
			memcpy(cf->data, rx->cl1.data, datalen);
		else
			memcpy(cf->data, rx->cl2.data, datalen);
	}
}

static int ixxat_usb_handle_canmsg(struct ixxat_usb_device *dev,
				   struct ixxat_can_msg *rx)
{
	int err = 0;
	const u32 ixx_flags = le32_to_cpu(rx->base.flags);
	const u8 dlc = IXXAT_USB_DECODE_DLC(ixx_flags);
	struct canfd_frame *cf;
	struct net_device *netdev = dev->netdev;
	struct sk_buff *skb;
	u8 datalen;
	u8 min_size;
	u32 MsgIdx = 0;
	int len;

	if (ixx_flags & IXXAT_USB_FDMSG_FLAGS_EDL)
		datalen = can_fd_dlc2len(dlc);
	else
		datalen = can_cc_dlc2len(dlc);

	min_size = sizeof(rx->base) + datalen;

	if (dev->adapter == &usb2can_cl1)
		min_size += sizeof(rx->cl1) - sizeof(rx->cl1.data);
	else
		min_size += sizeof(rx->cl2) - sizeof(rx->cl2.data);

	if (rx->base.size < (min_size - 1)) {
		netdev_err(netdev, "Error: CAN Invalid data message size\n");
		err = -EBADMSG;
	} else {

		if (ixx_flags & IXXAT_USB_MSG_FLAGS_OVR) {
			netdev->stats.rx_over_errors++;
			netdev->stats.rx_errors++;
			ix_trace_printk("CAN Message overflow\n");
		}

		if (ixx_flags & IXXAT_USB_MSG_FLAGS_SRR) {
			if (dev->adapter == &usb2can_cl1) {
				// do nothing because the tx_packets are already handled
				// in the write callback !

			} else {
				netdev->stats.tx_bytes += datalen;
				netdev->stats.tx_packets++;

				MsgIdx = le32_to_cpu(rx->cl2.client_id);

				if (MsgIdx >= IXXAT_USB_MSG_IDX_OFFSET) {
						MsgIdx -= IXXAT_USB_MSG_IDX_OFFSET;

						len = can_get_echo_skb(netdev, MsgIdx, NULL);
						ixxat_usb_msg_free_idx(dev, MsgIdx);
				}
			}
			netif_wake_queue(netdev);

		} else {
			if (ixx_flags & IXXAT_USB_FDMSG_FLAGS_EDL)
				skb = alloc_canfd_skb(netdev, &cf);
			else
				skb = alloc_can_skb(netdev, (struct can_frame **)&cf);

 			if (!skb) {
				err = -ENOMEM;
			} else {

				ixxat_convert(dev->adapter, cf, rx, datalen);
				ixxat_usb_get_ts_tv(dev, le32_to_cpu(rx->base.time), &skb->tstamp);

				netdev->stats.rx_packets++;
				netdev->stats.rx_bytes += cf->len;
				netif_rx(skb);
				err = 0;
			}
		}
	}

	return err;
}

static int ixxat_usb_handle_status(struct ixxat_usb_device *dev,
				   struct ixxat_can_msg *rx)
{
	int err = 0;
	struct net_device *netdev = dev->netdev;
	struct can_frame *can_frame;
	struct sk_buff *skb;
	enum can_state new_state = CAN_STATE_ERROR_ACTIVE;
	u32 raw_status;
	u8 min_size = sizeof(rx->base) + sizeof(raw_status);

	if (dev->adapter == &usb2can_cl1)
		min_size += sizeof(rx->cl1) - sizeof(rx->cl1.data);
	else
		min_size += sizeof(rx->cl2) - sizeof(rx->cl2.data);

	if (rx->base.size < (min_size - 1)) {
		netdev_err(netdev, "Error: CAN Invalid status message size\n");
		err = -EBADMSG;
	} else {
		if (dev->adapter == &usb2can_cl1)
			raw_status = le32_to_cpup((__le32 *)rx->cl1.data);
		else
			raw_status = le32_to_cpup((__le32 *)rx->cl2.data);

		if (raw_status != IXXAT_USB_CAN_STATUS_OK) {
			if (raw_status & IXXAT_USB_CAN_STATUS_BUSOFF) {
				dev->can.can_stats.bus_off++;
				new_state = CAN_STATE_BUS_OFF;
				can_bus_off(netdev);
			} else {
				if (raw_status & IXXAT_USB_CAN_STATUS_ERRLIM) {
					dev->can.can_stats.error_warning++;
					new_state = CAN_STATE_ERROR_WARNING;
				}

				if (raw_status & IXXAT_USB_CAN_STATUS_ERR_PAS) {
					dev->can.can_stats.error_passive++;
					new_state = CAN_STATE_ERROR_PASSIVE;
				}

				if (raw_status & IXXAT_USB_CAN_STATUS_OVERRUN)
					new_state = CAN_STATE_MAX;
			}
		}

		if (new_state == CAN_STATE_ERROR_ACTIVE) {
			dev->bec.txerr = 0;
			dev->bec.rxerr = 0;
		}

		if (new_state != CAN_STATE_MAX)
			dev->can.state = new_state;

		skb = alloc_can_err_skb(netdev, &can_frame);
		if (!skb) {
			err = -ENOMEM;
		} else {

			switch (new_state) {
			case CAN_STATE_ERROR_ACTIVE:
				can_frame->can_id |= CAN_ERR_CRTL;
				can_frame->data[1] |= CAN_ERR_CRTL_ACTIVE;
				break;
			case CAN_STATE_ERROR_WARNING:
				can_frame->can_id |= CAN_ERR_CRTL;
				can_frame->data[1] |= CAN_ERR_CRTL_TX_WARNING;
				can_frame->data[1] |= CAN_ERR_CRTL_RX_WARNING;
				break;
			case CAN_STATE_ERROR_PASSIVE:
				can_frame->can_id |= CAN_ERR_CRTL;
				can_frame->data[1] |= CAN_ERR_CRTL_TX_PASSIVE;
				can_frame->data[1] |= CAN_ERR_CRTL_RX_PASSIVE;
				break;
			case CAN_STATE_BUS_OFF:
				can_frame->can_id |= CAN_ERR_BUSOFF;
				break;
			case CAN_STATE_MAX:
				can_frame->can_id |= CAN_ERR_CRTL;
				can_frame->data[1] |= CAN_ERR_CRTL_RX_OVERFLOW;
				break;
			default:
				netdev_err(netdev, "Error: CAN Unhandled status %d\n",
					   new_state);
				break;
			}

			netdev->stats.rx_packets++;
			netdev->stats.rx_bytes += can_frame->can_dlc;
			netif_rx(skb);
		}
	}

	return err;
}

static int ixxat_usb_handle_error(struct ixxat_usb_device *dev,
				  struct ixxat_can_msg *rx)
{
	struct net_device *netdev = dev->netdev;
	struct can_frame *can_frame;
	struct sk_buff *skb;
	u8 raw_error;
	u8 min_size = sizeof(rx->base) + IXXAT_USB_CAN_ERROR_LEN;
	int err;

	if (dev->adapter == &usb2can_cl1)
		min_size += sizeof(rx->cl1) - sizeof(rx->cl1.data);
	else
		min_size += sizeof(rx->cl2) - sizeof(rx->cl2.data);

	if (rx->base.size < (min_size - 1)) {
		netdev_err(netdev, "Error: CAN Invalid error message size\n");
		return -EBADMSG;
	}

	if (dev->can.state == CAN_STATE_BUS_OFF) {
		err = 0;
	} else {

		if (dev->adapter == &usb2can_cl1) {
			raw_error = rx->cl1.data[IXXAT_USB_CAN_ERROR_CODE];
			dev->bec.rxerr = rx->cl1.data[IXXAT_USB_CAN_ERROR_COUNTER_RX];
			dev->bec.txerr = rx->cl1.data[IXXAT_USB_CAN_ERROR_COUNTER_TX];
		} else {
			raw_error = rx->cl2.data[IXXAT_USB_CAN_ERROR_CODE];
			dev->bec.rxerr = rx->cl2.data[IXXAT_USB_CAN_ERROR_COUNTER_RX];
			dev->bec.txerr = rx->cl2.data[IXXAT_USB_CAN_ERROR_COUNTER_TX];
		}

		if (raw_error == IXXAT_USB_CAN_ERROR_ACK)
			netdev->stats.tx_errors++;
		else
			netdev->stats.rx_errors++;

		skb = alloc_can_err_skb(netdev, &can_frame);
		if (!skb)
			return -ENOMEM;

		switch (raw_error) {
		case IXXAT_USB_CAN_ERROR_ACK:
			can_frame->can_id |= CAN_ERR_ACK;
			break;
		case IXXAT_USB_CAN_ERROR_BIT:
			can_frame->can_id |= CAN_ERR_PROT;
			can_frame->data[2] |= CAN_ERR_PROT_BIT;
			break;
		case IXXAT_USB_CAN_ERROR_CRC:
			can_frame->can_id |= CAN_ERR_PROT;
			can_frame->data[3] |= CAN_ERR_PROT_LOC_CRC_SEQ;
			break;
		case IXXAT_USB_CAN_ERROR_FORM:
			can_frame->can_id |= CAN_ERR_PROT;
			can_frame->data[2] |= CAN_ERR_PROT_FORM;
			break;
		case IXXAT_USB_CAN_ERROR_STUFF:
			can_frame->can_id |= CAN_ERR_PROT;
			can_frame->data[2] |= CAN_ERR_PROT_STUFF;
			break;
		default:
			can_frame->can_id |= CAN_ERR_PROT;
			can_frame->data[2] |= CAN_ERR_PROT_UNSPEC;
			break;
		}

		netdev->stats.rx_packets++;
		netdev->stats.rx_bytes += can_frame->can_dlc;
		netif_rx(skb);

		err = 0;
	}

	return err;
}

static int ixxat_usb_decode_buf(struct urb *urb)
{
	int ret = 0;
	struct ixxat_usb_device *dev = urb->context;
	struct net_device *netdev = dev->netdev;
	struct ixxat_can_msg *can_msg;
	int err = 0;
	u32 pos = 0;
	u8 *data = urb->transfer_buffer;
//  u32 len = le32_to_cpu(urb->actual_length);
	u32 len = urb->actual_length;

	while (pos < len) {
		u32 time;
		u32 type;
		u32 size;

		can_msg = (struct ixxat_can_msg *)&data[pos];
		if (!can_msg || !can_msg->base.size) {
			err = -ENOTSUPP;
			netdev_err(netdev, "Error %d: USB Unsupported msg\n",
				   err);
			ret = -1;
			break;
		}

		size = can_msg->base.size + 1;
		if (size < sizeof(can_msg->base) || (pos + size) > len) {
			err = -EBADMSG;
			netdev_err(netdev,
				   "Error %d: USB Invalid message size\n",
				   err);
			ret = -1;
			break;
		}

		type = le32_to_cpu(can_msg->base.flags);
		type &= IXXAT_USB_MSG_FLAGS_TYPE;

		switch (type) {
		case IXXAT_USB_CAN_DATA:
			err = ixxat_usb_handle_canmsg(dev, can_msg);
			if (err)
				goto fail;
			break;

		case IXXAT_USB_CAN_STATUS:
			err = ixxat_usb_handle_status(dev, can_msg);
			if (err)
				goto fail;
			break;

		case IXXAT_USB_CAN_ERROR:
			err = ixxat_usb_handle_error(dev, can_msg);
			if (err)
				goto fail;
			break;

		case IXXAT_USB_CAN_TIMEOVR:
			time = le32_to_cpu(can_msg->base.time);
			ixxat_usb_get_ts_tv(dev, time, NULL);
			break;

		case IXXAT_USB_CAN_INFO:
		case IXXAT_USB_CAN_WAKEUP:
		case IXXAT_USB_CAN_TIMERST:
			break;

		default:
			netdev_err(netdev,
				   "CAN Unhandled rec type 0x%02x (%d): ignored\n",
				   type, type);
			ret = -1;
			break;
		}

		pos += size;
	}

fail:
	if (err) {

		netdev_err(netdev, "Error %d: Buffer decoding failed\n", err);
		ret = -1;
	}


  return ret;

}

static int ixxat_usb_encode_msg(struct ixxat_usb_device *dev,
				struct sk_buff *skb, u8 *obuf, u8 selfReception, u32 uMsgIdx)
{
	int size;
	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
	struct ixxat_can_msg can_msg = { {0} };
	struct ixxat_can_msg_base *msg_base = &can_msg.base;
	u32 flags = 0;
	u32 msg_id = 0;

	if (cf->can_id & CAN_RTR_FLAG)
		flags |= IXXAT_USB_MSG_FLAGS_RTR;

	if (cf->can_id & CAN_EFF_FLAG) {
		flags |= IXXAT_USB_MSG_FLAGS_EXT;
		msg_id = cf->can_id & CAN_EFF_MASK;
	} else {
		msg_id = cf->can_id & CAN_SFF_MASK;
	}

	if (can_is_canfd_skb(skb)) {
		flags |= IXXAT_USB_FDMSG_FLAGS_EDL;

		if (!(cf->can_id & CAN_RTR_FLAG) && (cf->flags & CANFD_BRS))
			flags |= IXXAT_USB_FDMSG_FLAGS_FDR;

		flags |= IXXAT_USB_ENCODE_DLC(can_fd_len2dlc(cf->len));
	} else {
		flags |= IXXAT_USB_ENCODE_DLC(cf->len);
	}

	msg_base->size = sizeof(*msg_base) + cf->len - 1;
	if (dev->adapter == &usb2can_cl1) {
		msg_base->size += sizeof(can_msg.cl1);
		msg_base->size -= sizeof(can_msg.cl1.data);
		memcpy(can_msg.cl1.data, cf->data, cf->len);

		if (selfReception)
			flags |= IXXAT_USB_MSG_FLAGS_SRR;

	} else {
		msg_base->size += sizeof(can_msg.cl2);
		msg_base->size -= sizeof(can_msg.cl2.data);
		memcpy(can_msg.cl2.data, cf->data, cf->len);

		if (selfReception) {
			flags |= IXXAT_USB_MSG_FLAGS_SRR;
			can_msg.cl2.client_id = cpu_to_le32(uMsgIdx);
		}
		else
			can_msg.cl2.client_id = 0;
	}

	msg_base->flags = cpu_to_le32(flags);
	msg_base->msg_id = cpu_to_le32(msg_id);

	size = msg_base->size + 1;
	memcpy(obuf, &can_msg, size);
	return size;
}

static int ixxat_evaluate_usb_status (struct net_device *netdev,
		struct urb *urb,
		u8 ep_msg)
{
	// 0: success, -1: error -> return, -2: error -> retry
	int err = 0;

	if (!netif_device_present(netdev))
		err = -1;
	else
		switch (urb->status) {
		case 0: /* success */
			err = 0;
			break;
		case -EPROTO:
		case -EILSEQ:
		case -ENOENT:
		case -ECONNRESET:
		case -ESHUTDOWN:
			err = -1;
			break;
		default:
			err = -2;
			break;
		}

#ifdef DEBUG
		if ( urb->status != 0)
			switch (urb->status) {
			case 0: /* success */
				err = 0;
				break;
			case -EPROTO:
				netdev_err(netdev, "EP: %x, Protocol error /(%d)\n", ep_msg, urb->status);
				break;
			case -EILSEQ:
				netdev_err(netdev, "EP: %x, Illegal byte sequence /(%d)\n", ep_msg, urb->status);
				break;
			case -ENOENT:
				netdev_err(netdev, "EP: %x, No such file or directory /(%d)\n", ep_msg, urb->status);
				break;
			case -ECONNRESET:
				netdev_err(netdev, "EP: %x, Connection reset by peer /(%d)\n", ep_msg, urb->status);
				break;
			case -ESHUTDOWN:
				netdev_err(netdev, "EP: %x, Cannot send after transport endpoint shutdown /(%d)\n", ep_msg, urb->status);
				break;
			default:
				netdev_err(netdev, "EP: %x, Urb Status /(%d)\n", ep_msg, urb->status);
				break;
			}
#endif

	return err;
}


static void ixxat_usb_read_bulk_callback(struct urb *urb)
{
	int ret = 0;
	struct ixxat_usb_device *dev = urb->context;
	const struct ixxat_usb_adapter *adapter = dev->adapter;
	struct net_device *netdev = dev->netdev;
	struct usb_device *udev = dev->udev;
	int err;

	err = ixxat_evaluate_usb_status(netdev, urb, dev->ep_msg_in);

	if ( 0 == err )	{
		ret = 0;

		if (urb->actual_length > 0) {
			if (dev->state & IXXAT_USB_STATE_STARTED)
				ret = ixxat_usb_decode_buf(urb);
		}

		//resubmit_urb:
		if ( 0 == ret ) {
		//	ix_trace_printk ("callback: fill_bulk_urb %x \n", dev->ep_msg_in);
			usb_fill_bulk_urb(urb, udev,
				usb_rcvbulkpipe(udev, dev->ep_msg_in),
				urb->transfer_buffer, adapter->buffer_size_rx,
				ixxat_usb_read_bulk_callback, dev);

			usb_anchor_urb(urb, &dev->rx_anchor);
			err = usb_submit_urb(urb, GFP_ATOMIC);

			if (err) {
				usb_unanchor_urb(urb);

				if (err == -ENODEV)
					netif_device_detach(netdev);
				else
					netdev_err(netdev,
						"Error %d: Failed to resubmit read bulk urb\n", err);
			}
		}
	}
}



static void ixxat_usb_write_bulk_callback(struct urb *urb)
{
	struct ixxat_tx_urb_context *context = urb->context;
	struct ixxat_usb_device *dev;
	struct net_device *netdev;
	u32 MsgIdx;
	int iSkbRet;
	int	err;

	if (!context)
		return;

	dev = context->dev;
	netdev = dev->netdev;

	err = ixxat_evaluate_usb_status(netdev, urb, dev->ep_msg_out);
	switch (err) {
	default:
	case 0:
		break;
	case -1:
		return;
	case -2:
		goto prepare_urb;
		break;
	}

	// find correct MsgIdx with the CAN Id and Len
	MsgIdx = context->msg_index;

	if (MsgIdx < IXXAT_USB_MAX_MSGS) {
		iSkbRet = can_get_echo_skb(netdev, MsgIdx, NULL);

		if (iSkbRet) {
			netdev->stats.tx_bytes += iSkbRet;
			netdev->stats.tx_packets += 1;
		} else {
			// if no loopback is active
			netdev->stats.tx_bytes += context->msg_packet_len;
			netdev->stats.tx_packets += context->msg_packet_no;
		}

		ixxat_usb_msg_free_idx(dev, MsgIdx);
	}

prepare_urb:

	context->msg_index = IXXAT_USB_MAX_MSGS;

	ixxat_usb_rel_tx_context(dev, context);
	atomic_dec(&dev->active_tx_urbs);
	netif_wake_queue(netdev);
}

#define IX_LOOP_DIS	0x00	//disable self reception
#define IX_LOOP_SELF_RX	0x01	//enable self reception
#define IX_LOOPBACK	0x02	//pass on message to application
static u8 determineLoopMode(bool loopback, bool global_loopback, bool oldDev)
{
	// decision if this message should be loopbacked !!
	u8 loopMode = IX_LOOP_DIS;

	// exact statistics means that all messages are sent with active
	// self reception ( overhead ) so that the statistic counter are incremented
	// after the message was really on the can bus, otherwise the counter is
	// incremented after the WriteURB returns
	const bool statistics_exact = IX_STATISTICS_EXACT;

	// is loopback set with ip link .. loopback on
	if (global_loopback == true) {

		// is loopback set with setsockopt
		// can be changed between message transmission

		if (loopback)
			loopMode = (IX_LOOP_SELF_RX | IX_LOOPBACK);
	}

	if ((loopMode & IX_LOOP_SELF_RX) != IX_LOOP_SELF_RX) {
		if (statistics_exact)
			loopMode = IX_LOOP_SELF_RX;
	}

	// the old firmware doesn't support a clientid
	// -> so there is no exact loopback or statistic possible
	if (oldDev)
		loopMode &= ~IX_LOOP_SELF_RX;

	return loopMode;
}

static netdev_tx_t ixxat_usb_start_xmit(struct sk_buff *skb,
					struct net_device *netdev)
{
	int err = NETDEV_TX_OK;
	int size;
	struct ixxat_usb_device *dev = netdev_priv(netdev);
	struct ixxat_tx_urb_context *context = NULL;
	struct net_device_stats *stats = &netdev->stats;
	struct urb *urb;
	u8 *obuf;
	u32 MsgIdx;
	u8	loopMode;
	bool isloopback    = false;
	bool selfReception = false;

#if LINUX_VERSION_CODE < KERNEL_VERSION(6, 1, 0)
	if (can_dropped_invalid_skb(netdev, skb))
		return NETDEV_TX_OK;
#else
	if (can_dev_dropped_skb(netdev, skb))
		return NETDEV_TX_OK;
#endif 

	// find free URB
	context = ixxat_usb_get_tx_context(dev);

	if (!context) { // !context
		//if (WARN_ON_ONCE(!context)) {
		netif_stop_queue(netdev);
		err = NETDEV_TX_BUSY;
	} else {
		// get free msg number ( Client Id )
		MsgIdx = ixxat_usb_msg_get_next_idx(dev);

		if (MsgIdx == IXXAT_USB_E_FAILED) {
			ixxat_usb_rel_tx_context(dev, context);
			netif_stop_queue(netdev);
			err = NETDEV_TX_BUSY;
		}
	}

	if (err == NETDEV_TX_OK) {
		// reset to be sure that no old value is stored !
		context->msg_index = IXXAT_USB_MAX_MSGS;

		// prepare the Urb
		urb  = context->urb;
		obuf = urb->transfer_buffer;

		// check loopback
		loopMode = determineLoopMode((skb->pkt_type == PACKET_LOOPBACK),
										dev->loopback,
										dev->adapter == &usb2can_cl1);

		isloopback = ((loopMode & IX_LOOPBACK) == IX_LOOPBACK);
		selfReception = ((loopMode & IX_LOOP_SELF_RX) == IX_LOOP_SELF_RX);

		if (!selfReception) {

			// handle the reception in the USB callback
			if (!isloopback) {
				struct can_frame *cf = (struct can_frame *)skb->data;

				context->msg_packet_len = cf->can_dlc;
				context->msg_packet_no = 1;
			}

			// store the MsgIdx in the Urb
			context->msg_index = MsgIdx;
		}

		size = ixxat_usb_encode_msg(dev, skb, obuf, selfReception, MsgIdx + IXXAT_USB_MSG_IDX_OFFSET);

		if (isloopback) {
			can_put_echo_skb(skb, netdev, MsgIdx, 0);
		}
		else {
			dev_kfree_skb(skb);
		}

#ifdef DEBUG
		showdump(obuf, size);
#endif
		urb->transfer_buffer_length = size;
		usb_anchor_urb(urb, &dev->tx_anchor);

		atomic_inc(&dev->active_tx_urbs);
		err = usb_submit_urb(urb, GFP_ATOMIC);

		if (err) { // submit failed

			// should only free if it's exist
			can_free_echo_skb(netdev, MsgIdx, NULL);
			ixxat_usb_msg_free_idx(dev, MsgIdx);
			ixxat_usb_rel_tx_context(dev, context);

			usb_unanchor_urb(urb);
			atomic_dec(&dev->active_tx_urbs);

			if (err == -ENODEV) {
				netif_device_detach(netdev);
			} else {
				stats->tx_dropped++;
				netdev_err(netdev, "Error %d: Submitting tx-urb failed\n", err);
			}
		}
	}

	return err;
}

static int ixxat_usb_setup_rx_urbs(struct ixxat_usb_device *dev)
{
	int i;
	int err = 0;
	const struct ixxat_usb_adapter *adapter = dev->adapter;
	struct net_device *netdev = dev->netdev;
	struct usb_device *udev = dev->udev;

	for (i = 0; i < IXXAT_USB_MAX_RX_URBS; i++) {
		struct urb *urb;
		u8 *buf;

		urb = usb_alloc_urb(0, GFP_KERNEL);
		if (!urb) {
			err = -ENOMEM;
			netdev_err(netdev, "Error %d: No memory for URBs\n",
				   err);
			break;
		}

		ix_trace_printk ("setup: kmalloc %x \n", adapter->buffer_size_rx);
		buf = kmalloc(adapter->buffer_size_rx, GFP_KERNEL);

		if (buf) {
			dev->rx_buf[i] = buf;
		} else {
			usb_free_urb(urb);
			err = -ENOMEM;
			netdev_err(netdev,
				   "Error %d: No memory for USB-buffer\n", err);
			break;
		}

		ix_trace_printk ("setup: fill_bulk_urb %i \n", dev->ep_msg_in);
		usb_fill_bulk_urb(urb, udev,
				  usb_rcvbulkpipe(udev, dev->ep_msg_in), buf,
				  adapter->buffer_size_rx,
				  ixxat_usb_read_bulk_callback, dev);

		urb->transfer_flags |= URB_FREE_BUFFER;
		usb_anchor_urb(urb, &dev->rx_anchor);

		err = usb_submit_urb(urb, GFP_KERNEL);
		if (err) {
			usb_unanchor_urb(urb);

			dev->rx_buf[i] = NULL;
			kfree(buf);

			usb_free_urb(urb);

			if (err == -ENODEV)
				netif_device_detach(netdev);

			break;
		}

		usb_free_urb(urb);
	}

	if (i == 0)
		netdev_err(netdev, "Error: Couldn't setup any rx-URBs\n");

	return err;
}

static int ixxat_usb_setup_tx_urbs(struct ixxat_usb_device *dev)
{
	int UrbIdx;
	int ret = 0;
	const struct ixxat_usb_adapter *adapter = dev->adapter;
	struct net_device *netdev = dev->netdev;
	struct usb_device *udev = dev->udev;

	for (UrbIdx = 0; UrbIdx < IXXAT_USB_MAX_TX_URBS; UrbIdx++) {
		struct ixxat_tx_urb_context *context;
		struct urb *urb;
		u8 *buf;

		urb = usb_alloc_urb(0, GFP_KERNEL);

		if (urb) {
			buf = kmalloc(adapter->buffer_size_tx, GFP_KERNEL);

			if (buf) {
				context = dev->tx_contexts + UrbIdx;

				context->dev = dev;
				context->urb = urb;
				context->urb_index    = IXXAT_USB_FREE_ENTRY;
				usb_fill_bulk_urb(urb, udev,
						  usb_sndbulkpipe(udev, dev->ep_msg_out), buf,
						  adapter->buffer_size_tx,
						  ixxat_usb_write_bulk_callback, context);

				urb->transfer_flags |= URB_FREE_BUFFER;

			} else {
				usb_free_urb(urb);
				ret = -ENOMEM;
				netdev_err(netdev,
					   "Error %d: No memory for USB-buffer\n", ret);
				break;
			}

		} else {
			ret = -ENOMEM;
			netdev_err(netdev, "Error %d: No memory for URBs\n",
				   ret);
			break;
		}
	}

	if (UrbIdx == 0) {
		netdev_err(netdev, "Error: Couldn't setup any tx-URBs\n");
		usb_kill_anchored_urbs(&dev->rx_anchor);
	}

	return ret;
}

/*
 * sysfs attributes
 */
static ssize_t show_serial(struct device *pdev,
		struct device_attribute *attr, char *buf)
{
	struct net_device *netdev = to_net_dev(pdev);
	struct ixxat_usb_device *dev = netdev_priv(netdev);
	return sprintf(buf, "%.*s\n", (int)(sizeof(dev->dev_info.device_id)), dev->dev_info.device_id);
}
static DEVICE_ATTR(serial, S_IRUGO, show_serial, NULL);

static ssize_t show_firmware_version(struct device *pdev,
		struct device_attribute *attr, char *buf)
{
	struct net_device *netdev = to_net_dev(pdev);
	struct ixxat_usb_device *dev = netdev_priv(netdev);
	return sprintf(buf, "%d.%d.%d.%d\n"
		, le16_to_cpu(dev->fw_info.major_version)
		, le16_to_cpu(dev->fw_info.minor_version)
		, le16_to_cpu(dev->fw_info.build_version)
		, le16_to_cpu(dev->fw_info.revision));
}
static DEVICE_ATTR(firmware_version, S_IRUGO, show_firmware_version, NULL);

static ssize_t show_hardware(struct device *pdev,
		struct device_attribute *attr, char *buf)
{
	struct net_device *netdev = to_net_dev(pdev);
	struct ixxat_usb_device *dev = netdev_priv(netdev);
	return sprintf(buf, "%.*s\n", (int)(sizeof(dev->dev_info.device_name)), dev->dev_info.device_name);
}
static DEVICE_ATTR(hardware, S_IRUGO, show_hardware, NULL);

static ssize_t show_hardware_version(struct device *pdev,
		struct device_attribute *attr, char *buf)
{
	struct net_device *netdev = to_net_dev(pdev);
	struct ixxat_usb_device *dev = netdev_priv(netdev);
	return sprintf(buf, "0x%04X\n", dev->dev_info.device_version);
}
static DEVICE_ATTR(hardware_version, S_IRUGO, show_hardware_version, NULL);

static ssize_t show_fpga_version(struct device *pdev,
		struct device_attribute *attr, char *buf)
{
	struct net_device *netdev = to_net_dev(pdev);
	struct ixxat_usb_device *dev = netdev_priv(netdev);
	return sprintf(buf, "0x%08X\n", dev->dev_info.device_fpga_version);
}
static DEVICE_ATTR(fpga_version, S_IRUGO, show_fpga_version, NULL);

static struct attribute *ixxat_pdev_attrs[] = {
	&dev_attr_serial.attr,
	&dev_attr_firmware_version.attr,
	&dev_attr_hardware.attr,
	&dev_attr_hardware_version.attr,
	&dev_attr_fpga_version.attr,
	NULL,
};

static const struct attribute_group ixxat_pdev_group = {
	.name = NULL,
	.attrs = ixxat_pdev_attrs,
};


static void ixxat_usb_disconnect(struct usb_interface *intf)
{
	struct ixxat_usb_device *dev;
	struct ixxat_usb_device *prev_dev;

	ix_trace_printk (">> ixxat_usb_disconnect\n");

	/* unregister the given device and all previous devices */
	for (dev = usb_get_intfdata(intf); dev; dev = prev_dev) {
		prev_dev = dev->prev_dev;
		sysfs_remove_group(&dev->netdev->dev.kobj, &ixxat_pdev_group);
		unregister_candev(dev->netdev);
		free_candev(dev->netdev);
	}

	usb_set_intfdata(intf, NULL);

	ix_trace_printk ("<< ixxat_usb_disconnect\n");
}

static int ixxat_usb_start(struct ixxat_usb_device *dev)
{
	int err;
	int i;
	u32 time_ref = 0;
	const struct ixxat_usb_adapter *adapter = dev->adapter;

	err = ixxat_usb_setup_rx_urbs(dev);
	if (err)
		return err;

	err = ixxat_usb_setup_tx_urbs(dev);
	if (err)
		return err;

	/* Try to reset the controller, in case it is already initialized
	 * from a previous unclean shutdown
	 */
	ixxat_usb_reset_ctrl(dev);

	if (adapter->init_ctrl) {
		err = adapter->init_ctrl(dev);
		if (err)
			goto fail;
	}

	if (!(dev->state & IXXAT_USB_STATE_STARTED)) {
		err = ixxat_usb_start_ctrl(dev, &time_ref);
		if (err)
			goto fail;

		ixxat_usb_set_ts_now(dev, time_ref);
	}

	dev->bec.txerr = 0;
	dev->bec.rxerr = 0;

	dev->state |= IXXAT_USB_STATE_STARTED;
	dev->can.state = CAN_STATE_ERROR_ACTIVE;

	return 0;

fail:
	if (err == -ENODEV)
		netif_device_detach(dev->netdev);

	netdev_err(dev->netdev, "Error %d: Couldn't submit control\n", err);

	for (i = 0; i < IXXAT_USB_MAX_TX_URBS; i++) {
		usb_free_urb(dev->tx_contexts[i].urb);
		dev->tx_contexts[i].urb = NULL;
	}

	return err;
}

static int ixxat_usb_open(struct net_device *netdev)
{
	struct ixxat_usb_device *dev = netdev_priv(netdev);
	int err;

	/* common open */
	err = open_candev(netdev);
	if (err)
		goto fail;

	/* finally start device */
	err = ixxat_usb_start(dev);
	if (err) {
		netdev_err(netdev, "Error %d: Couldn't start device.\n", err);
		close_candev(netdev);
		goto fail;
	}

	netif_start_queue(netdev);

fail:
	return err;
}

static int ixxat_usb_stop(struct net_device *netdev)
{
	int err = 0;
	struct ixxat_usb_device *dev = netdev_priv(netdev);

	ix_trace_printk (">> ixxat_usb_stop\n");

	ixxat_usb_free_usb_communication(dev);

	if (dev->state & IXXAT_USB_STATE_STARTED) {
		err = ixxat_usb_stop_ctrl(dev);
		if (err)
//			netdev_warn(netdev, "Error %d: Cannot stop device\n",err);
			ix_trace_printk ("Error %d: Cannot stop device\n",err);
	}

	dev->state &= ~IXXAT_USB_STATE_STARTED;
	close_candev(netdev);
	dev->can.state = CAN_STATE_STOPPED;

	ix_trace_printk (">> ixxat_usb_stop\n");
	return err;
}

static const struct net_device_ops ixxat_usb_netdev_ops = {
	.ndo_open = ixxat_usb_open,
	.ndo_stop = ixxat_usb_stop,
	.ndo_start_xmit = ixxat_usb_start_xmit,
	.ndo_change_mtu = can_change_mtu,
};

static const char *ixxat_usb_dev_name(u16 id)
{
	switch (id) {
	case USB2CAN_COMPACT_PRODUCT_ID:
		return "IXXAT USB Compact";
	case USB2CAN_EMBEDDED_PRODUCT_ID:
		return "IXXAT USB Embedded";
	case USB2CAN_PROFESSIONAL_PRODUCT_ID:
		return "IXXAT USB Professional";
	case USB2CAN_AUTOMOTIVE_PRODUCT_ID:
		return "IXXAT USB Automotive";
	case USB2CAN_PLUGIN_PRODUCT_ID:
		return "IXXAT USB Plugin";
	case USB2CAN_FD_COMPACT_PRODUCT_ID:
		return "IXXAT USB Compact FD";
	case USB2CAN_FD_PROFESSIONAL_PRODUCT_ID:
		return "IXXAT USB Professional FD";
	case USB2CAN_FD_AUTOMOTIVE_PRODUCT_ID:
		return "IXXAT USB Automotive FD";
	case USB2CAN_FD_PCIE_MINI_PRODUCT_ID:
		return "IXXAT USB PCIE Mini FD";
	case USB2CAR_PRODUCT_ID:
		return "IXXAT USB-to-Car";
	case CAN_IDM101_PRODUCT_ID:
		return "IXXAT IDM 101";
	case CAN_IDM200_PRODUCT_ID:
		return "IXXAT IDM 200";
	default:
		return "IXXAT USB Unknown";
	}
}

static const struct ixxat_usb_adapter *ixxat_usb_get_adapter(const u16 id, struct ixxat_fw_info2 *dev_fwinfo)
{
	const struct ixxat_usb_adapter *pAdapter = NULL;

	switch (id) {
	case USB2CAN_COMPACT_PRODUCT_ID:
	case USB2CAN_EMBEDDED_PRODUCT_ID:
	case USB2CAN_PROFESSIONAL_PRODUCT_ID:
	case USB2CAN_AUTOMOTIVE_PRODUCT_ID:
	case USB2CAN_PLUGIN_PRODUCT_ID:
		pAdapter = &usb2can_cl1;

		if (dev_fwinfo) {
			if ( IX_MINIMUM_CL2_FWVERSION(*dev_fwinfo) ) {
				pAdapter = &usb2can_v2;
			}
		}
		break;

	case USB2CAN_FD_COMPACT_PRODUCT_ID:
	case USB2CAN_FD_PROFESSIONAL_PRODUCT_ID:
	case USB2CAN_FD_AUTOMOTIVE_PRODUCT_ID:
	case USB2CAN_FD_PCIE_MINI_PRODUCT_ID:
	case USB2CAR_PRODUCT_ID:
		pAdapter = &usb2can_fd;
		break;

	case CAN_IDM101_PRODUCT_ID:
	case CAN_IDM200_PRODUCT_ID:
		pAdapter = &can_fd_idm;
		break;

	default:
		pAdapter = NULL;
	}

	return pAdapter;
}

static int ixxat_usb_create_ctrl(struct usb_interface *intf,
				const struct ixxat_usb_adapter *adapter,
				u16 ctrl_index,
				struct ixxat_dev_info *dev_devinfo,
				struct ixxat_fw_info2 *dev_fwinfo)
{
	struct usb_device *udev = interface_to_usbdev(intf);
	struct ixxat_usb_device *dev;
	struct net_device *netdev;
	int err;
	int i;

	netdev = alloc_candev(sizeof(*dev), IXXAT_USB_MAX_MSGS); // number of echo_skb

	if (netdev) {
		dev = netdev_priv(netdev);

		// must be identical to the can.echo_skb_max set
		// This is necessary to correctly handle the loopback option
		dev->msg_max = IXXAT_USB_MAX_MSGS;

		dev->udev = udev;
		dev->netdev = netdev;
		dev->adapter = adapter;
		dev->ctrl_index = ctrl_index;
		dev->state = IXXAT_USB_STATE_CONNECTED;

		spin_lock_init(&dev->dev_lock);

		i = ctrl_index + adapter->ep_offs;
		dev->ep_msg_in = adapter->ep_msg_in[i];
		dev->ep_msg_out = adapter->ep_msg_out[i];

		dev->can.clock.freq = adapter->clock;
		dev->can.bittiming_const = adapter->bt;
		dev->can.data_bittiming_const = adapter->btd;

		dev->can.restart_ms = IXXAT_USB_DEFAULT_RESTART_MS;
		dev->can.ctrlmode_supported = adapter->modes;

		// map function
		dev->can.do_set_mode = ixxat_usb_set_mode;
		dev->can.do_get_berr_counter = ixxat_usb_get_berr_counter;

		//
		// configure communication
		//

		init_usb_anchor(&dev->rx_anchor);
		init_usb_anchor(&dev->tx_anchor);

		atomic_set(&dev->active_tx_urbs, 0);

		for (i = 0; i < IXXAT_USB_MAX_TX_URBS; i++)
			dev->tx_contexts[i].urb_index = IXXAT_USB_FREE_ENTRY;

		ixxat_usb_msg_free_idx(dev, 0xFFFFFFFF);

		//
		// configure netdev
		//
		netdev->netdev_ops = &ixxat_usb_netdev_ops;
		netdev->flags |= IFF_ECHO;

		// link this device into the existing list
		dev->prev_dev = usb_get_intfdata(intf);
		usb_set_intfdata(intf, dev);

		SET_NETDEV_DEV(netdev, &intf->dev);
		err = register_candev(netdev);
		if (err) {
			dev_err(&intf->dev, "Error %d: Failed to register can device\n",
				err);
			goto free_candev;
		}

		if (dev->prev_dev)
			(dev->prev_dev)->next_dev = dev;

		if (dev_devinfo) {
			memcpy(&dev->dev_info, dev_devinfo, sizeof(dev->dev_info));
		} else {
			memset(&dev->dev_info, 0, sizeof(dev->dev_info));
		}

		if (dev_fwinfo) {
			memcpy(&dev->fw_info, dev_fwinfo, sizeof(dev->fw_info));
		} else {
			memset(&dev->fw_info, 0, sizeof(dev->fw_info));
		}

		netdev->addr_len = sizeof(dev->dev_info.device_id);
#if LINUX_VERSION_CODE < KERNEL_VERSION(5, 17, 0)
		netdev->dev_addr = dev->dev_info.device_id;
#else
		dev_addr_mod(netdev, 0, dev->dev_info.device_id, sizeof(dev->dev_info.device_id));
#endif

		netdev->dev_id = ctrl_index;
		netdev->dev_port = ctrl_index;

		err = sysfs_create_group(&netdev->dev.kobj, &ixxat_pdev_group);
		if (err < 0) {
			netdev_err(netdev, "Error: %d: create sysfs failed\n", err);
			goto free_candev;
		}

		netdev_info(netdev, "%.*s: Connected channel %u (device %.*s)\n",
				(int)sizeof(dev->dev_info.device_name), dev->dev_info.device_name, ctrl_index,
				(int)sizeof(dev->dev_info.device_id), dev->dev_info.device_id);


		err = 0;
	} else {
		dev_err(&intf->dev, "Cannot allocate candev\n");
		err =  -ENOMEM;
	}

	return err;

free_candev:
	sysfs_remove_group(&netdev->dev.kobj, &ixxat_pdev_group);
	usb_set_intfdata(intf, dev->prev_dev);
	free_candev(netdev);
	return err;
}

static int ixxat_usb_check_channel(const struct ixxat_usb_adapter *adapter,
				const struct usb_host_interface *host_intf)
{
	u16 i;
	int err = NETDEV_TX_OK;

	for (i = 0; i < host_intf->desc.bNumEndpoints; i++) {
		const u8 epaddr = host_intf->endpoint[i].desc.bEndpointAddress;
		int match = 0;
		u8 j;

		/* Check if usb-endpoint address matches known usb-endpoints */
		for (j = 0; j < IXXAT_USB_MAX_CHANNEL; j++) {
			u8 ep_msg_in = adapter->ep_msg_in[j];
			u8 ep_msg_out = adapter->ep_msg_out[j];

			if (epaddr == ep_msg_in || epaddr == ep_msg_out) {
				match = 1;
				break;
			}
		}

		if (!match) {
			err = -ENODEV;
			break;
		}
	}

	return err;
}


static int ixxat_usb_probe(struct usb_interface *intf,
			   const struct usb_device_id *id)
{
	struct usb_device *udev = interface_to_usbdev(intf);
	const struct ixxat_usb_adapter *adapter;
	struct ixxat_dev_caps dev_caps    = {0};
	struct ixxat_fw_info2 dev_fwinfo  = {0};
	struct ixxat_dev_info dev_devinfo = {0};

	u16 i;
	int err;

	printk(IX_DRIVER_TAG "KERNELVERSION: 0x%x (%i)", LINUX_VERSION_CODE, LINUX_VERSION_CODE);

	err = ixxat_usb_get_fw_info(udev, &dev_fwinfo);
	if (err) {
		dev_err(&udev->dev, "Error %d: Failed to get firmware information. Maybe firmware update needed.\n", err);
	}
	else
	{
		if (IXXAT_USB_DEV_FWTYPE_BAL != le32_to_cpu(dev_fwinfo.firmware_type))
		{
			dev_err(&udev->dev, "Error %d: Unknown firmware type. Expected %u, got %u. Maybe firmware or driver update needed.\n", err, IXXAT_USB_DEV_FWTYPE_BAL, le32_to_cpu(dev_fwinfo.firmware_type));
			err = -EFAULT;
		}

		if (!err)
		{
			// check if FW supports get_fw_info2 command
			if ( IX_MINIMUM_CL2_FWVERSION(dev_fwinfo) )
			{
				err = ixxat_usb_get_fw_info2(udev, &dev_fwinfo);
				if (err) {
					dev_err(&udev->dev, "Error %d: Failed to get firmware info2. Maybe firmare update needed.\n", err);
				}
			}
		}
	}

	if (err) {
		adapter = ixxat_usb_get_adapter(id->idProduct, NULL);
	} else {
		adapter = ixxat_usb_get_adapter(id->idProduct, &dev_fwinfo);
	}

	if (adapter) {
		dev_info(&udev->dev, "%s\n", ixxat_usb_dev_name(id->idProduct));

		err = ixxat_usb_check_channel(adapter, intf->altsetting);

		if (err == NETDEV_TX_OK) {
			err = ixxat_usb_power_ctrl(udev, IXXAT_USB_POWER_WAKEUP);
			if (err != NETDEV_TX_OK) {
				dev_err(&udev->dev, "Error %d: Failed to exec IXXAT_USB_BRD_CMD_POWER command.\n", err);
			}
			msleep(IXXAT_USB_POWER_WAKEUP_TIME);
		}

		if (err == NETDEV_TX_OK) {
			err = ixxat_usb_get_dev_info(udev, &dev_devinfo);
			if (err) {
				dev_err(&udev->dev,
					"Error %d: Failed to get device information\n", err);
			}
		}

		if (err == NETDEV_TX_OK) {
			printk(IX_DRIVER_TAG "Device type     : %.*s\n", (int)(sizeof(dev_devinfo.device_name)), dev_devinfo.device_name);
			printk(IX_DRIVER_TAG "Device id       : %.*s\n", (int)(sizeof(dev_devinfo.device_id)), dev_devinfo.device_id);
			printk(IX_DRIVER_TAG "Device version  : 0x%08X\n", dev_devinfo.device_version);
			printk(IX_DRIVER_TAG "FPGA version    : 0x%08X\n", dev_devinfo.device_fpga_version);
			printk(IX_DRIVER_TAG "Firmware version: %d.%d.%d.%d (type: %d)"
				, le16_to_cpu(dev_fwinfo.major_version)
				, le16_to_cpu(dev_fwinfo.minor_version)
				, le16_to_cpu(dev_fwinfo.build_version)
				, le16_to_cpu(dev_fwinfo.revision)
				, le32_to_cpu(dev_fwinfo.firmware_type));

			if (! IX_MINIMUM_CL2_FWVERSION(dev_fwinfo) )
			{
				printk(IX_DRIVER_TAG "                  Firmware update recommended.\n");
			}
		}

		if (err == NETDEV_TX_OK) {
			err = ixxat_usb_get_dev_caps(udev, &dev_caps);

			if (err) {
				dev_err(&intf->dev,
					"Error %d: Failed to get device capabilities\n", err);
			}
		}

		if (err == NETDEV_TX_OK) {
			err = -ENODEV;
#ifdef DEBUG
			showdevcaps(dev_caps);
#endif

			for (i = 0; i < le16_to_cpu(dev_caps.bus_ctrl_count); i++) {
				u16 dev_bustype = le16_to_cpu(dev_caps.bus_ctrl_types[i]);
				u8 bustype = IXXAT_USB_BUS_TYPE(dev_bustype);

				if (bustype == IXXAT_USB_BUS_CAN)
					err = ixxat_usb_create_ctrl(intf, adapter, i, &dev_devinfo, &dev_fwinfo);

				if (err) {
					/* deregister already created devices */
					ixxat_usb_disconnect(intf);
					break;
				}
			}
		}
	} else {
		dev_err(&intf->dev, "%s: Unknown device id %d\n",
			KBUILD_MODNAME, id->idProduct);
		err = -ENODEV;
	}

	return err;
}

static struct usb_driver ixxat_usb_driver = {
	.name = KBUILD_MODNAME,
	.probe = ixxat_usb_probe,
	.disconnect = ixxat_usb_disconnect,
	.id_table = ixxat_usb_table,
};

module_usb_driver(ixxat_usb_driver);

