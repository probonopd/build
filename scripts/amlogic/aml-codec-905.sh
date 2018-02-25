#!/bin/sh

build_aml_codec_905()
{
	display_alert "Build aml-codec-905" "@host" "info"

	local plugin_dir="aml-codec-905"
	local plugin_repo="https://github.com/150balbes/pkg-aml"
	local plugin_dir="aml-codec-905"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir
	fetch_from_repo "$plugin_repo" "$plugin_dir" "branch:aml-codec-905"
	rm -R $SOURCES/$plugin_dir/.git
	cd $SOURCES/$plugin_dir

	# set up control file
	mkdir -p DEBIAN
	cat <<-END > DEBIAN/control
	Package: aml-codec-905
	Version: $REVISION
	Architecture: $ARCH
	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
	Installed-Size: 1
	Provides: aml-codec-905
	Conflicts: aml-codec-905
	Section: kernel
	Priority: optional
	Description: lib codec S905
	END

	cd $SOURCES
	# pack
	mv aml-codec-905 aml-codec-905_${REVISION}_${ARCH}
	dpkg -b aml-codec-905_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv aml-codec-905_${REVISION}_${ARCH} aml-codec-905
	mv aml-codec-905_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving aml-codec-905 package" "" "wrn"
}

[[ ! -f $DEST/debs/aml-codec-905_${REVISION}_${ARCH}.deb ]] && build_aml_codec_905

# install mali by default
display_alert "Installing aml-codec-905" "$REVISION" "info"
install_deb_chroot "$DEST/debs/aml-codec-905_${REVISION}_${ARCH}.deb"  >> $DEST/debug/install.log
