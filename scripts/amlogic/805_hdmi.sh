#!/bin/sh

#bpp=32
bpp=24

#hdmimode=1080i
hdmimode=720p

echo "$hdmimode" > /sys/class/display/mode

# Disable framebuffer scaling
echo 0 > /sys/class/ppmgr/ppscaler
echo 0 > /sys/class/graphics/fb0/free_scale
echo 1 > /sys/class/graphics/fb0/freescale_mode
echo 0 > /sys/class/graphics/fb1/free_scale

# Set framebuffer geometry to match the resolution
case $hdmimode in
  720*)
	fbset -fb /dev/fb0 -g 1280 720 1280 1440 $bpp
    ;;
  1080*)
	fbset -fb /dev/fb0 -g 1920 1080 1920 2160 $bpp
    ;;
esac

# Enable framebuffer device
echo 0 > /sys/class/graphics/fb0/blank

# Blank fb1 to prevent static noise
echo 1 > /sys/class/graphics/fb1/blank

#su -c 'hciattach /dev/ttyS1 any'

