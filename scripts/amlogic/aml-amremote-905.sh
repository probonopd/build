#!/bin/sh

build_amremote()
{
	display_alert "Build aml-amremote-905" "@host" "info"

	local plugin_repo="https://github.com/150balbes/pkg-aml"
	local plugin_dir="aml-amremote-905"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir
	fetch_from_repo "$plugin_repo" "$plugin_dir" "branch:aml-amremote-905"
	rm -R $SOURCES/$plugin_dir/.git
	cd $SOURCES/$plugin_dir

	# set up control file
	mkdir -p DEBIAN
	cat <<-END > DEBIAN/control
	Package: aml-amremote-905
	Version: $REVISION
	Architecture: $ARCH
	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
	Installed-Size: 1
	Provides: aml-amremote-905
	Conflicts: aml-amremote-905
	Section: kernel
	Priority: optional
	Description: IR amremote S905
	END

	cd $SOURCES
	# pack
	mv aml-amremote-905 aml-amremote-905_${REVISION}_${ARCH}
	dpkg -b aml-amremote-905_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv aml-amremote-905_${REVISION}_${ARCH} aml-amremote-905
	mv aml-amremote-905_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving aml-amremote-905 package" "" "wrn"
}

[[ ! -f $DEST/debs/aml-amremote-905_${REVISION}_${ARCH}.deb ]] && build_amremote

# install
display_alert "Installing aml-amremote-905" "$REVISION" "info"
chroot $SDCARD /bin/bash -c "dpkg -i /tmp/debs/aml-amremote-905_${REVISION}_${ARCH}.deb" >> $DEST/debug/install.log
chroot $SDCARD /bin/bash -c "systemctl --no-reload enable amlogic-remotecfg.service >/dev/null 2>&1"
