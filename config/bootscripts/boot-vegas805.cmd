setenv condev "console=ttyS0,115200n8 console=tty0 no_console_suspend consoleblank=0"
setenv bootargs "root=LABEL=ROOTFS rootflags=data=writeback rw ${condev} fsck.repair=yes net.ifnames=0 mac=${mac}"
setenv kernel_loadaddr "0x14000000"
setenv dtb_loadaddr "0x11800000"
setenv initrd_loadaddr "0x15000000"
setenv boot_start bootm ${kernel_loadaddr} ${initrd_loadaddr} ${dtb_loadaddr}
if fatload mmc 0 ${initrd_loadaddr} uInitrd; then if fatload mmc 0 ${kernel_loadaddr} uImage; then if fatload mmc 0 ${dtb_loadaddr} dtb.img; then run boot_start; else imgread dtb boot ${loadaddr} ${dtb_loadaddr}; run boot_start;fi;fi;fi;
if fatload usb 0 ${initrd_loadaddr} uInitrd; then if fatload usb 0 ${kernel_loadaddr} uImage; then if fatload usb 0 ${dtb_loadaddr} dtb.img; then run boot_start; else imgread dtb boot ${loadaddr} ${dtb_loadaddr}; run boot_start;fi;fi;fi;
if fatload usb 1 ${initrd_loadaddr} uInitrd; then if fatload usb 1 ${kernel_loadaddr} uImage; then if fatload usb 1 ${dtb_loadaddr} dtb.img; then run boot_start; else imgread dtb boot ${loadaddr} ${dtb_loadaddr}; run boot_start;fi;fi;fi;
if fatload usb 2 ${initrd_loadaddr} uInitrd; then if fatload usb 2 ${kernel_loadaddr} uImage; then if fatload usb 2 ${dtb_loadaddr} dtb.img; then run boot_start; else imgread dtb boot ${loadaddr} ${dtb_loadaddr}; run boot_start;fi;fi;fi;
if fatload usb 3 ${initrd_loadaddr} uInitrd; then if fatload usb 3 ${kernel_loadaddr} uImage; then if fatload usb 3 ${dtb_loadaddr} dtb.img; then run boot_start; else imgread dtb boot ${loadaddr} ${dtb_loadaddr}; run boot_start;fi;fi;fi;

#if fatload mmc 0 ${initrd_loadaddr} uInitrd; then if fatload mmc 0 ${kernel_loadaddr} uImage; then if fatload mmc 0 ${dtb_loadaddr} dtb.img; then run boot_start;fi;fi;fi;
#if fatload usb 0 ${initrd_loadaddr} uInitrd; then if fatload usb 0 ${kernel_loadaddr} uImage; then if fatload usb 0 ${dtb_loadaddr} dtb.img; then run boot_start;fi;fi;fi;
