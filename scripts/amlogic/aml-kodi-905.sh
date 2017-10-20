#!/bin/sh

build_kodi_aml()
{
	display_alert "Build aml-kodi-905" "@host" "info"

	local plugin_repo="https://github.com/150balbes/pkg-aml"
	local plugin_dir="aml-kodi-905"
	[[ -d "$SOURCES/$plugin_dir" && -n "$SOURCES$plugin_dir" ]] && rm -rf $SOURCES/$plugin_dir
	fetch_from_repo "$plugin_repo" "$plugin_dir" "branch:aml-kodi-905"
	rm -R $SOURCES/$plugin_dir/.git
	cd $SOURCES/$plugin_dir

	# set up control file
	mkdir -p DEBIAN
	cat <<-END > DEBIAN/control
	Package: aml-kodi-905
	Version: $REVISION
	Architecture: $ARCH
	Maintainer: $MAINTAINER <$MAINTAINERMAIL>
	Installed-Size: 1
	Provides: aml-kodi-905
	Conflicts: aml-kodi-905
	Depends:
	Section: utils
	Priority: optional
	Description: aml-kodi-905
	END

	cd $SOURCES
	# pack
	mv aml-kodi-905 aml-kodi-905_${REVISION}_${ARCH}
	dpkg -b aml-kodi-905_${REVISION}_${ARCH} >> $DEST/debug/install.log 2>&1
	mv aml-kodi-905_${REVISION}_${ARCH} aml-kodi-905
	mv aml-kodi-905_${REVISION}_${ARCH}.deb $DEST/debs/ || display_alert "Failed moving aml-kodi-905 package" "" "wrn"
}

[[ ! -f $DEST/debs/aml-kodi-905_${REVISION}_${ARCH}.deb ]] && build_kodi_aml

# install
display_alert "Installing aml-kodi-905" "$REVISION" "info"
install_deb_chroot "$DEST/debs/aml-kodi-905_${REVISION}_${ARCH}.deb"  >> $DEST/debug/install.log
