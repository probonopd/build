#!/bin/sh

echo 0 > /sys/class/ppmgr/ppscaler
echo 0 > /sys/class/graphics/fb0/free_scale
echo 1 > /sys/class/graphics/fb0/freescale_mode
echo 0 > /sys/class/graphics/fb1/free_scale

echo "720p" > /sys/class/display/mode
fbset -fb /dev/fb0 -g 1280 720 1280 1440 24
echo 0 > /sys/class/graphics/fb0/blank
echo 1 > /sys/class/graphics/fb1/blank

echo "1080p" > /sys/class/display/mode
fbset -fb /dev/fb0 -g 1920 1080 1920 2160 24
echo 0 > /sys/class/graphics/fb0/blank
echo 1 > /sys/class/graphics/fb1/blank

#echo 0 > /sys/devices/virtual/graphics/fbcon/cursor_blink
