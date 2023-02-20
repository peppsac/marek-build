#!/bin/bash

prefix=${PREFIX:-/usr}

top_folder=$(dirname "$0")
if test x$1 = x32; then
    cross_compile="--cross-file $top_folder/i386.ini --cross-file $top_folder/cross-build.ini"
    archdir=i386-linux-gnu
else
    archdir=x86_64-linux-gnu
    cross_compile="--cross-file $top_folder/x86_64.ini --cross-file $top_folder/cross-build.ini"
fi

rm -r build$1

set -e

cflags="-fno-omit-frame-pointer"

meson build$1 $cross_compile --prefix $prefix --libdir $prefix/lib/$archdir --buildtype debugoptimized \
	-Dc_args=$cflags -Dc_link_args=$cflags -Dpkg_config_path=$prefix/lib/$archdir/pkgconfig \
	-Detnaviv=false -Dexynos=false -Dfreedreno=false -Domap=false -Dtegra=false -Dvc4=false \
	-Dcairo-tests=false -Dvalgrind=false -Dintel=false
