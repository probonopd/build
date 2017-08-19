
build_firmware-aml()
{
	display_alert "Merging and packaging linux firmware-aml" "@host" "info"

	local plugin_repo="https://github.com/150balbes/pkg-aml"
	local plugin_dir="firmware-aml"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir

	fetch_from_repo "$plugin_repo" "$plugin_dir/lib" "branch:firmware-aml"

	rm -R $SOURCES/$plugin_dir/lib/.git

	cd $SOURCES/$plugin_dir

	# set up control file
	mkdir -p DEBIAN
	cat <<-END > DEBIAN/control
	Package: firmware-aml
	Version: $REVISION
	Architecture: $ARCH
	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
	Installed-Size: 1
	Replaces: linux-firmware
	Section: kernel
	Priority: optional
	Description: Linux firmware-aml
	END

	cd $SOURCES
	# pack
	mv firmware-aml firmware-aml_${REVISION}_${ARCH}
	dpkg -b firmware-aml_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv firmware-aml_${REVISION}_${ARCH} firmware-aml
	mv firmware-aml_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving firmware-aml package" "" "wrn"
}

[[ ! -f $DEST/debs/firmware-aml_${REVISION}_${ARCH}.deb ]] && build_firmware-aml

# install basic firmware by default
display_alert "Installing firmware-aml" "$REVISION" "info"
chroot $SDCARD /bin/bash -c "dpkg -i /tmp/debs/firmware-aml_${REVISION}_${ARCH}.deb" >> $DEST/debug/install.log
