#!/bin/sh

#bpp=32
bpp=24

#mode=1080p
mode=720p

HPD_STATE=/sys/class/amhdmitx/amhdmitx0/hpd_state
DISP_CAP=/sys/class/amhdmitx/amhdmitx0/disp_cap
DISP_MODE=/sys/class/display/mode

echo $mode > $DISP_MODE

outputmode=$mode

common_display_setup() {
	fbset -fb /dev/fb1 -g 32 32 32 32 32
	echo $outputmode > /sys/class/display/mode
	echo 0 > /sys/class/ppmgr/ppscaler
	echo 0 > /sys/class/graphics/fb0/free_scale
	echo 1 > /sys/class/graphics/fb0/freescale_mode

	case $outputmode in
        	800x480*) M="0 0 799 479" ;;
	        vga*)  M="0 0 639 749" ;;
	        800x600p60*) M="0 0 799 599" ;;
	        1024x600p60h*) M="0 0 1023 599" ;;
	        1024x768p60h*) M="0 0 1023 767" ;;
	        sxga*) M="0 0 1279 1023" ;;
        	1440x900p60*) M="0 0 1439 899" ;;
	        480*) M="0 0 719 479" ;;
	        576*) M="0 0 719 575" ;;
        	720*) M="0 0 1279 719" ;;
        	800*) M="0 0 1279 799" ;;
        	1080*) M="0 0 1919 1079" ;;
        	1920x1200*) M="0 0 1919 1199" ;;
        	1680x1050p60*) M="0 0 1679 1049" ;;
		1360x768p60*) M="0 0 1359 767" ;;
		1366x768p60*) M="0 0 1365 767" ;;
		1600x900p60*) M="0 0 1599 899" ;;
	esac

	echo $M > /sys/class/graphics/fb0/free_scale_axis
	echo $M > /sys/class/graphics/fb0/window_axis
	echo 0x10001 > /sys/class/graphics/fb0/free_scale
	echo 0 > /sys/class/graphics/fb1/free_scale
}

case $mode in
	800x480*)	fbset -fb /dev/fb0 -g 800 480 800 960 $bpp;	common_display_setup ;;
	vga*)		fbset -fb /dev/fb0 -g 640 480 640 960 $bpp;	common_display_setup ;;
	480*)		fbset -fb /dev/fb0 -g 720 480 720 960 $bpp;	common_display_setup ;;
	800x600p60*)	fbset -fb /dev/fb0 -g 800 600 800 1200 $bpp;	common_display_setup ;;
	576*)		fbset -fb /dev/fb0 -g 720 576 720 1152 $bpp;	common_display_setup ;;
	1024x600p60h*)	fbset -fb /dev/fb0 -g 1024 600 1024 1200 $bpp;	common_display_setup ;;
	1024x768p60h*)	fbset -fb /dev/fb0 -g 1024 768 1024 1536 $bpp;	common_display_setup ;;
	720*)		fbset -fb /dev/fb0 -g 1280 720 1280 1440 $bpp;	common_display_setup ;;
	800*)		fbset -fb /dev/fb0 -g 1280 800 1280 1600 $bpp;	common_display_setup ;;
	sxga*)		fbset -fb /dev/fb0 -g 1280 1024 1280 2048 $bpp;	common_display_setup ;;
	1440x900p60*)	fbset -fb /dev/fb0 -g 1440 900 1440 1800 $bpp;	common_display_setup ;;
	1080*)		fbset -fb /dev/fb0 -g 1920 1080 1920 2160 $bpp;	common_display_setup ;;
	1920x1200*)	fbset -fb /dev/fb0 -g 1920 1200 1920 2400 $bpp;	common_display_setup ;;
	1360x768p60*)	fbset -fb /dev/fb0 -g 1360 768 1360 1536 $bpp;	common_display_setup ;;
	1366x768p60*)	fbset -fb /dev/fb0 -g 1366 768 1366 1536 $bpp;	common_display_setup ;;
	1600x900p60*)	fbset -fb /dev/fb0 -g 1600 900 1600 1800 $bpp;	common_display_setup ;;
	1680x1050p60*)	fbset -fb /dev/fb0 -g 1680 1050 1680 2100 $bpp;	common_display_setup ;;
	
esac

# Console unblack
echo 0 > /sys/class/graphics/fb0/blank
echo 1 > /sys/class/graphics/fb1/blank

# Move IRQ's of ethernet to CPU1/2
#echo 1,2 > /proc/irq/40/smp_affinity_list

#docker daemon

#/etc/webmin/start &
