
install_modules()
{
	display_alert "Make qca9377" "@host" "info"
	local plugin_repo="https://github.com/150balbes/pkg-aml"
	local plugin_dir="qca9377"
#	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir
	fetch_from_repo "$plugin_repo" "$plugin_dir" "branch:qca9377"

	cd $SOURCES/$plugin_dir

	make -s ARCH=$ARCHITECTURE CROSS_COMPILE="$CCACHE $KERNEL_COMPILER" clean >> $DEST/debug/compilation.log 2>&1
	KERNEL_SRC=$SOURCES/$LINUXSOURCEDIR/ CONFIG_CLD_HL_SDIO_CORE=y make -s -j4 ARCH=$ARCHITECTURE CROSS_COMPILE="$CCACHE $KERNEL_COMPILER" >> $DEST/debug/compilation.log 2>&1
	cp qca9377.ko $CACHEDIR/$SDCARD/lib/modules/$VER/kernel/drivers/amlogic/
	depmod -b $CACHEDIR/$SDCARD/ $VER
#	make -s clean >/dev/null

}

display_alert "Installing module" "qca9377" "info"
install_modules
