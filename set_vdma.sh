#!/bin/sh

width=1920
height=1080
bpp=3

interface_bar=resource2
gpio_bar=resource4

# reset the DMA unit
# ./pcimem ${interface_bar} 0x0 w 0x10084

# MM2S vertical size -- set to 0 to restart flow
# ./pcimem ${interface_bar} 0x50 w 0

# MM2S_reg_index - set to 0
./pcimem ${interface_bar} 0x14 w 0

# MM2S horizontal size
#./pcimem ${interface_bar} 0x54 w 0x1680  # 1920 * 3
./pcimem ${interface_bar} 0x54 w $((${width} * ${bpp}))  # 1920 * 4

# MM2S frame delay and stride
# line stride is same as horizontal size, no frame delay because no genlock
#./pcimem ${interface_bar} 0x58 w 0x1680
./pcimem ${interface_bar} 0x58 w $((${width} * ${bpp}))

# MM2S start address  0x5C is bank 0
# start from address 0
./pcimem ${interface_bar} 0x5c w 0

# MM2S vertical size -- must be written last for a given channel
./pcimem ${interface_bar} 0x50 w ${height}

# VDMACR  -- puts VDMA in run mode
#   0001 0000 0000 1000 0011
./pcimem ${interface_bar} 0x0 w 0x10083

# start listening to the intenal DMA path
./pcimem ${gpio_bar} 0x0 w 2
