#!/bin/sh

build_amremote()
{
	display_alert "Build amremote" "@host" "info"

	local plugin_dir="amremote"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES/$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir

	mkdir -p $SOURCES/$plugin_dir/
	cp -R $SRC/lib/scripts/amlogic/amremote/* $SOURCES/$plugin_dir/

	cd $SOURCES/$plugin_dir

	# set up control file
	mkdir -p DEBIAN
	cat <<-END > DEBIAN/control
	Package: amremote
	Version: $REVISION
	Architecture: $ARCH
	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
	Installed-Size: 1
	Provides: amremote
	Conflicts: amremote
	Section: kernel
	Priority: optional
	Description: IR amremote
	END

	cd $SOURCES
	# pack
	mv amremote amremote_${REVISION}_${ARCH}
	dpkg -b amremote_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv amremote_${REVISION}_${ARCH} amremote
	mv amremote_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving amremote package" "" "wrn"
}

[[ ! -f $DEST/debs/amremote_${REVISION}_${ARCH}.deb ]] && build_amremote

# install mali by default
display_alert "Installing amremote" "$REVISION" "info"
chroot $CACHEDIR/$SDCARD /bin/bash -c "dpkg -i /tmp/debs/amremote_${REVISION}_${ARCH}.deb" >> $DEST/debug/install.log
chroot $CACHEDIR/$SDCARD /bin/bash -c "systemctl --no-reload enable amlogic-remotecfg.service >/dev/null 2>&1"
