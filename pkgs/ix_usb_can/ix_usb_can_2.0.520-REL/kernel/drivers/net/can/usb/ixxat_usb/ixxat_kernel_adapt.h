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
#include <linux/version.h>

#ifndef IXXAT_LNX_KERNEL_ADAPT_H
#define IXXAT_LNX_KERNEL_ADAPT_H

#if LINUX_VERSION_CODE < KERNEL_VERSION(5, 11, 0)
	#define can_fd_dlc2len(dlc)		can_dlc2len(get_canfd_dlc(dlc))
	#define can_fd_len2dlc(dlc)		can_len2dlc(dlc)
	#define can_cc_dlc2len(dlc)		get_can_dlc(dlc)
#endif

#if LINUX_VERSION_CODE < KERNEL_VERSION(5, 12, 0)
	#define can_get_echo_skb(dev,idx,pLen)    can_get_echo_skb(dev,idx)
	#define can_put_echo_skb(skb,dev,idx,len) can_put_echo_skb(skb,dev,idx)
#endif

#if LINUX_VERSION_CODE < KERNEL_VERSION(5, 13, 0)
	#define can_free_echo_skb(dev,idx,pLen)   can_free_echo_skb(dev,idx)
#endif

#if LINUX_VERSION_CODE < KERNEL_VERSION(5, 19, 0)
	#define netif_napi_add_weight(dev, napi, poll, wait) netif_napi_add(dev, napi, poll, wait)
#endif

#endif