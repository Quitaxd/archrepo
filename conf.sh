#!/usr/bin/env bash

REPODIR="$HOME/Projects/archrepo/x86_64"
PKGBUILDDIR="$HOME/Projects/archrepo/pkgbuild"
OLDDIR="$PWD"
REPONAME="qrepo"

if [ "$1" == "" ]; then
	printf "Flags: add, rebuild, push\n"
fi

addpkg() {
	cd $PKGBUILDDIR
	if [ -d "$PKGNAME" ]; then
		rm -rf $PKGNAME
	fi
	git clone https://aur.archlinux.org/$PKGNAME.git
	cd $PKGNAME
	makepkg -s
	cp *.pkg.tar.zst $REPODIR
	cd $REPODIR
	repo-add $REPONAME.db.tar.gz *.pkg.tar.zst
	rm $REPONAME.{db,files}
	mv $REPONAME.db.tar.gz $REPONAME.db
	mv $REPONAME.files.tar.gz $REPONAME.files
	cd $OLDDIR
}

buildrepo() {
	cd $REPODIR
	repo-add $REPONAME.db.tar.gz *.pkg.tar.zst
	cd $REPODIR
	rm $REPONAME.{db,files}
	mv $REPONAME.db.tar.gz $REPONAME.db
	mv $REPONAME.files.tar.gz $REPONAME.files
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
	PKGNAME="$2"
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

