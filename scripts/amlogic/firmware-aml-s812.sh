
build_firmware-aml-s812()
{
	display_alert "Merging and packaging linux firmware-aml-s812" "@host" "info"

	local plugin_repo="https://github.com/150balbes/pkg-aml"
	local plugin_dir="firmware-aml-s812"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir

	fetch_from_repo "$plugin_repo" "$plugin_dir/lib" "branch:firmware-aml-s812"

	rm -R $SOURCES/$plugin_dir/lib/.git

	cd $SOURCES/$plugin_dir

	# set up control file
	mkdir -p DEBIAN
	cat <<-END > DEBIAN/control
	Package: firmware-aml-s812
	Version: $REVISION
	Architecture: $ARCH
	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
	Installed-Size: 1
	Replaces: linux-firmware
	Section: kernel
	Priority: optional
	Description: Linux firmware-aml-s812
	END

	cd $SOURCES
	# pack
	mv firmware-aml-s812 firmware-aml-s812_${REVISION}_${ARCH}
	dpkg -b firmware-aml-s812_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv firmware-aml-s812_${REVISION}_${ARCH} firmware-aml-s812
	mv firmware-aml-s812_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving firmware-aml-s812 package" "" "wrn"
}

[[ ! -f $DEST/debs/firmware-aml-s812_${REVISION}_${ARCH}.deb ]] && build_firmware-aml-s812

# install basic firmware by default
display_alert "Installing firmware-aml-s812" "$REVISION" "info"
install_deb_chroot "$DEST/debs/firmware-aml-s812_${REVISION}_${ARCH}.deb"  >> $DEST/debug/install.log
