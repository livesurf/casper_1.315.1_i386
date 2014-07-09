#!/bin/bash

cd ./root

SIZE=`du -s etc usr | awk '{ sum+=$1} END {print sum}'`
sed -i "s/^Installed-Size.*/Installed-Size: $SIZE/g" DEBIAN/control
md5sum `find etc usr -type f | sort` > DEBIAN/md5sums
VER=`grep '^Version:' DEBIAN/control | cut -d ' ' -f 2`
ARCH=`grep '^Architecture:' DEBIAN/control| cut -d ' ' -f 2`

cd -

DIR=$( mktemp -d )
rsync -axHAXS --cvs-exclude root "$DIR"

fakeroot dpkg-deb -Z lzma -b "$DIR/root" ../casper-tiny_${VER}_${ARCH}_$(date +%Y-%m-%d_%H:%M).deb 

rm -rf "$DIR"

