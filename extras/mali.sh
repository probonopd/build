#!/bin/sh

build_mali_aml()
{
	display_alert "Build mali-aml" "@host" "info"

	local plugin_dir="mali-aml"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES/$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir

	mkdir -p $SOURCES/$plugin_dir/
	cp -R $SRC/lib/scripts/amlogic/mali-aml/* $SOURCES/$plugin_dir/

	cd $SOURCES/$plugin_dir

	# set up control file
	mkdir -p DEBIAN
	cat <<-END > DEBIAN/control
	Package: mali-aml
	Version: $REVISION
	Architecture: $ARCH
	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
	Installed-Size: 1
	Provides: mali-aml
	Conflicts: mali-aml
	Section: kernel
	Priority: optional
	Description: lib mali
	END

	cd $SOURCES
	# pack
	mv mali-aml mali-aml_${REVISION}_${ARCH}
	dpkg -b mali-aml_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv mali-aml_${REVISION}_${ARCH} mali-aml
	mv mali-aml_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving mali-aml package" "" "wrn"
}

[[ ! -f $DEST/debs/mali-aml_${REVISION}_${ARCH}.deb ]] && build_mali_aml

# install mali by default
display_alert "Installing mali-aml" "$REVISION" "info"
chroot $CACHEDIR/$SDCARD /bin/bash -c "dpkg -i /tmp/debs/mali-aml_${REVISION}_${ARCH}.deb" >> $DEST/debug/install.log
