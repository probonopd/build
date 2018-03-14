#!/bin/sh

build_aml_mali()
{
	display_alert "Build aml-mali7" "@host" "info"

	local plugin_dir="aml-mali6"
	local plugin_repo="https://github.com/150balbes/pkg-aml"
	local plugin_dir="aml-mali7"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir
	fetch_from_repo "$plugin_repo" "$plugin_dir" "branch:aml-mali7"
	rm -R $SOURCES/$plugin_dir/.git
#	cd $SOURCES/$plugin_dir

	# set up control file
#	mkdir -p DEBIAN
#	cat <<-END > DEBIAN/control
#	Package: aml-mali6
#	Version: $REVISION
#	Architecture: $ARCH
#	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
#	Installed-Size: 1
#	Provides: aml-mali6
#	Conflicts: aml-mali6
#	Section: kernel
#	Priority: optional
#	Description: lib mali6
#	END

	cd $SOURCES
	# pack
	mv aml-mali7 aml-mali7_${REVISION}_${ARCH}
	dpkg -b aml-mali7_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv aml-mali7_${REVISION}_${ARCH} aml-mali6
	mv aml-mali7_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving aml-mali7 package" "" "wrn"
}

[[ ! -f $DEST/debs/aml-mali7_${REVISION}_${ARCH}.deb ]] && build_aml_mali

# install mali by default
display_alert "Installing aml-mali7" "$REVISION" "info"
install_deb_chroot "$DEST/debs/aml-mali7_${REVISION}_${ARCH}.deb"  >> $DEST/debug/install.log
