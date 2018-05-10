#!/bin/sh

build_kodi_aml()
{
	display_alert "Build aml-kodi-ubuntu-18" "@host" "info"

	local plugin_repo="https://github.com/150balbes/pkg-aml"
	local plugin_dir="aml-kodi-ubuntu-18"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir
	fetch_from_repo "$plugin_repo" "$plugin_dir" "branch:aml-kodi-ubuntu-18"
	rm -R $SOURCES/$plugin_dir/.git
#	cd $SOURCES/$plugin_dir

	# set up control file
#	mkdir -p DEBIAN
#	cat <<-END > DEBIAN/control
#	Package: aml-kodi-17
#	Version: $REVISION
#	Architecture: $ARCH
#	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
#	Installed-Size: 1
#	Provides: aml-kodi-17
#	Conflicts: aml-kodi-905
#	Depends: aml-amremote-905, aml-mali6, aml-codec
#	Section: video
#	Priority: optional
#	Description: aml-kodi-17
#	END

	cd $SOURCES
	# pack
	mv aml-kodi-ubuntu-18 aml-kodi-ubuntu-18_${REVISION}_${ARCH}
	dpkg -b aml-kodi-ubuntu-18_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv aml-kodi-ubuntu-18_${REVISION}_${ARCH} aml-kodi-ubuntu-18
	mv aml-kodi-ubuntu-18_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving aml-kodi-ubuntu-18 package" "" "wrn"
}

[[ ! -f $DEST/debs/aml-kodi-ubuntu-18_${REVISION}_${ARCH}.deb ]] && build_kodi_aml

# install
display_alert "Installing aml-kodi-ubuntu-18" "$REVISION" "info"
install_deb_chroot_apt "$DEST/debs/aml-kodi-ubuntu-18_${REVISION}_${ARCH}.deb"  >> $DEST/debug/install.log
