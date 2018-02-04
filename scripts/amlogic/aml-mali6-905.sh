#!/bin/sh

build_aml_mali6_905()
{
	display_alert "Build aml-mali6-905" "@host" "info"

	local plugin_dir="aml-mali6-905"
	local plugin_repo="https://github.com/150balbes/pkg-aml"
	local plugin_dir="aml-mali6-905"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir
	fetch_from_repo "$plugin_repo" "$plugin_dir" "branch:aml-mali6-905"
	rm -R $SOURCES/$plugin_dir/.git
	cd $SOURCES/$plugin_dir

	# set up control file
	mkdir -p DEBIAN
	cat <<-END > DEBIAN/control
	Package: aml-mali6-905
	Version: $REVISION
	Architecture: $ARCH
	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
	Installed-Size: 1
	Provides: aml-mali6-905
	Conflicts: aml-mali6-905
	Section: kernel
	Priority: optional
	Description: lib mali6 S905
	END

	cd $SOURCES
	# pack
	mv aml-mali6-905 aml-mali6-905_${REVISION}_${ARCH}
	dpkg -b aml-mali6-905_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv aml-mali6-905_${REVISION}_${ARCH} aml-mali6-905
	mv aml-mali6-905_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving aml-mali6-905 package" "" "wrn"
}

[[ ! -f $DEST/debs/aml-mali6-905_${REVISION}_${ARCH}.deb ]] && build_aml_mali6_905

# install mali by default
display_alert "Installing aml-mali6-905" "$REVISION" "info"
install_deb_chroot "$DEST/debs/aml-mali6-905_${REVISION}_${ARCH}.deb"  >> $DEST/debug/install.log
