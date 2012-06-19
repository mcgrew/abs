#!/bin/bash

REPO_NAME="mcgrew"
REPO_DIR="/var/www/html/archlinux/$REPO_NAME/os"

for i in $@; do
	if [ "${i:(-15)}" == "i686.pkg.tar.xz" ]; then
		echo "$i: arch = i686"
		mv -iv $i "$REPO_DIR/i686/"
	elif [ "${i:(-17)}" == "x86_64.pkg.tar.xz" ]; then
		echo "$i: arch = x86_64"
		mv -iv $i "$REPO_DIR/x86_64/"
	elif [ "${i:(-14)}" == "any.pkg.tar.xz" ]; then
		echo "$i: arch = any"
		cp -iv $i "$REPO_DIR/i686/"
		mv -iv $i "$REPO_DIR/x86_64/"
	fi;
done;


