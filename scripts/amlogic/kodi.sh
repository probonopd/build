#!/bin/sh

build_kodi_aml()
{
	display_alert "Build kodi-aml" "@host" "info"

	local plugin_dir="kodi-aml"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES/$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir

	mkdir -p $SOURCES/$plugin_dir/
	cp -R $SRC/scripts/amlogic/kodi-aml/* $SOURCES/$plugin_dir/

	cd $SOURCES/$plugin_dir

	# set up control file
	mkdir -p DEBIAN
	cat <<-END > DEBIAN/control
	Package: kodi-aml
	Version: $REVISION
	Architecture: $ARCH
	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
	Installed-Size: 1
	Provides: kodi-aml
	Conflicts: kodi-aml
	Depends:
	Section: utils
	Priority: optional
	Description: kodi-aml
	END

	cd $SOURCES
	# pack
	mv kodi-aml kodi-aml_${REVISION}_${ARCH}
	dpkg -b kodi-aml_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv kodi-aml_${REVISION}_${ARCH} kodi-aml
	mv kodi-aml_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving kodi-aml package" "" "wrn"
}

[[ ! -f $DEST/debs/kodi-aml_${REVISION}_${ARCH}.deb ]] && build_kodi_aml

# install mali by default
display_alert "Installing kodi-aml" "$REVISION" "info"
chroot $SDCARD /bin/bash -c "dpkg -i /tmp/debs/kodi-aml_${REVISION}_${ARCH}.deb" >> $DEST/debug/install.log
