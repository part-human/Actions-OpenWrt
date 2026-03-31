#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
# ============================================
# Increase network driver ring buffer size
# ============================================
echo "========================================="
echo "Modifying network driver ring buffer size"
echo "========================================="

# For MediaTek/Ralink routers (ramips target)
if [ -d "target/linux/ramips" ]; then
    DRIVER_FILE="target/linux/ramips/files/drivers/net/ethernet/ralink/ralink_soc_eth.c"
    if [ -f "$DRIVER_FILE" ]; then
        echo "Found ramips driver, modifying ring buffer..."
        sed -i 's/#define RX_RING_SIZE 128/#define RX_RING_SIZE 512/g' $DRIVER_FILE
        sed -i 's/#define TX_RING_SIZE 128/#define TX_RING_SIZE 512/g' $DRIVER_FILE
        echo "✅ Changed RX_RING_SIZE and TX_RING_SIZE from 128 to 512"
    else
        echo "⚠️  Driver file not found at: $DRIVER_FILE"
    fi
fi

# For Qualcomm Atheros routers (ath79 target)
if [ -d "target/linux/ath79" ]; then
    DRIVER_FILE="target/linux/ath79/files/drivers/net/ethernet/atheros/ag71xx.c"
    if [ -f "$DRIVER_FILE" ]; then
        echo "Found ath79 driver, modifying ring buffer..."
        sed -i 's/#define AG71XX_RX_RING_SIZE_DEFAULT 256/#define AG71XX_RX_RING_SIZE_DEFAULT 512/g' $DRIVER_FILE
        sed -i 's/#define AG71XX_TX_RING_SIZE_DEFAULT 256/#define AG71XX_TX_RING_SIZE_DEFAULT 512/g' $DRIVER_FILE
        echo "✅ Changed AG71XX ring buffer from 256 to 512"
    fi
fi

# For IPQ40xx routers
if [ -d "target/linux/ipq40xx" ]; then
    DRIVER_FILE="target/linux/ipq40xx/files/drivers/net/ethernet/qualcomm/eth_l2.c"
    if [ -f "$DRIVER_FILE" ]; then
        echo "Found ipq40xx driver, modifying ring buffer..."
        sed -i 's/#define RX_DESC_NUM 256/#define RX_DESC_NUM 512/g' $DRIVER_FILE
        echo "✅ Changed IPQ40xx ring buffer from 256 to 512"
    fi
fi

echo "========================================="
echo "Ring buffer modification complete"
echo "========================================="
