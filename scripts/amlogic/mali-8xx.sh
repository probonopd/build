#!/bin/sh

build_mali_aml()
{
	display_alert "Build mali-aml-8xx" "@host" "info"

	local plugin_dir="mali-aml-8xx"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES/$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir

	mkdir -p $SOURCES/$plugin_dir/
	cp -R $SRC/scripts/amlogic/mali-aml-8xx/* $SOURCES/$plugin_dir/

	cd $SOURCES/$plugin_dir

	# set up control file
	mkdir -p DEBIAN
	cat <<-END > DEBIAN/control
	Package: mali-aml-8xx
	Version: $REVISION
	Architecture: $ARCH
	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
	Installed-Size: 1
	Provides: mali-aml-8xx
	Conflicts: mali-aml-8xx
	Section: kernel
	Priority: optional
	Description: lib mali
	END

	cd $SOURCES
	# pack
	mv mali-aml-8xx mali-aml-8xx_${REVISION}_${ARCH}
	dpkg -b mali-aml-8xx_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv mali-aml-8xx_${REVISION}_${ARCH} mali-aml-8xx
	mv mali-aml-8xx_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving mali-aml-8xx package" "" "wrn"
}

[[ ! -f $DEST/debs/mali-aml-8xx_${REVISION}_${ARCH}.deb ]] && build_mali_aml

# install mali by default
display_alert "Installing mali-aml-8xx" "$REVISION" "info"
chroot $SDCARD /bin/bash -c "dpkg -i /tmp/debs/mali-aml-8xx_${REVISION}_${ARCH}.deb" >> $DEST/debug/install.log
