#!/usr/bin/env bash

REPODIR="~/Projects/archrepo/x86_64"
PKGBUILDDIR="~/Projects/archrepo/pkgbuild"
OLDDIR="$PWD"

addpkg() {
	cd $PKGBUILDDIR
	git clone https://aur.archlinux.org/$2.git
	cd $1
	makepkg -s
	cp *.pkg.tar.zst $REPODIR
	cd $OLDDIR
}

buildrepo() {
	cd $REPODIR
	repo-add qrepo.db.tar.gz *.pkg.tar.zst
	cd $OLDDIR
}

pushrepo() {
	cd $REPODIR
	git add .
	git commit -m "Update repo"
	git push
	cd $OLDDIR
}

if [ "$1" == "add" ]; then
	addpkg
	buildrepo
	pushrepo
fi

if [ "$1" == "rebuild" ]; then
	buildrepo
fi

if [ "$1" == "push" ]; then
	pushrepo
fi

