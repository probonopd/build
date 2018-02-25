#!/bin/sh

build_aml_mali6()
{
	display_alert "Build aml-mali6" "@host" "info"

	local plugin_dir="aml-mali6"
	local plugin_repo="https://github.com/150balbes/pkg-aml"
	local plugin_dir="aml-mali6"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir
	fetch_from_repo "$plugin_repo" "$plugin_dir" "branch:aml-mali6"
	rm -R $SOURCES/$plugin_dir/.git
	cd $SOURCES/$plugin_dir

	# set up control file
	mkdir -p DEBIAN
	cat <<-END > DEBIAN/control
	Package: aml-mali6
	Version: $REVISION
	Architecture: $ARCH
	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
	Installed-Size: 1
	Provides: aml-mali6
	Conflicts: aml-mali6
	Section: kernel
	Priority: optional
	Description: lib mali6
	END

	cd $SOURCES
	# pack
	mv aml-mali6 aml-mali6_${REVISION}_${ARCH}
	dpkg -b aml-mali6_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv aml-mali6_${REVISION}_${ARCH} aml-mali6
	mv aml-mali6_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving aml-mali6 package" "" "wrn"
}

[[ ! -f $DEST/debs/aml-mali6_${REVISION}_${ARCH}.deb ]] && build_aml_mali6

# install mali by default
display_alert "Installing aml-mali6" "$REVISION" "info"
install_deb_chroot "$DEST/debs/aml-mali6_${REVISION}_${ARCH}.deb"  >> $DEST/debug/install.log
