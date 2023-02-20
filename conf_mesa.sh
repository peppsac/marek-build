#!/bin/bash

prefix=${PREFIX:-/usr}
# for general development (optimized with assertions)
buildtype=${BUILD_TYPE:-debugoptimized}

top_folder=$(dirname "$0")
if test x$1 = x32; then
    arch=i386-linux-gnu
    va=false
    gallium_drivers=${GALLIUM_DRIVERS:-radeonsi}
    others="-Dplatforms=x11 -Dgallium-vdpau=disabled"
    cross_compile="--cross-file $top_folder/i386.ini --cross-file $top_folder/cross-build.ini"
else
    cross_compile="--cross-file $top_folder/x86_64.ini --cross-file $top_folder/cross-build.ini"
    arch=x86_64-linux-gnu
    va=enabled

    # comment or uncomment the following settings

    # for benchmarking (fastest, optimized without assertions)
    #buildtype=release; profile="-g"

    # for profiling (second fastest)
    #buildtype=release; profile="-g -fno-omit-frame-pointer"

    # for best debugging (no optimizations)
    #buildtype=debug

    gallium_drivers=${GALLIUM_DRIVERS:-radeonsi,swrast} # ,r300,r600,crocus,zink,virgl,nouveau,d3d12,svga,etnaviv,freedreno,iris,kmsro,lima,panfrost,tegra,v3d,vc4,asahi,i915

    vulkandrv=${VULKAN_DRIVERS:-} #,swrast

    #others="-Dgallium-xa=true -Dgallium-nine=true -Dgallium-omx=bellagio -Dbuild-tests=true -Dtools=glsl,nir"
    #others="-Dbuild-tests=true -Dtools=glsl,nir"
    videocodecs=h264dec,h264enc,h265dec,h265enc
fi

rm -r build$1

set -e

meson build$1 $cross_compile --prefix $prefix --libdir $prefix/lib/$arch --buildtype $buildtype -Dlibunwind=disabled -Dglvnd=true \
	-Dpkg_config_path=$PKG_CONFIG_PATH -Dvalgrind=disabled \
	-Dgallium-drivers=$gallium_drivers -Dvulkan-drivers=$vulkandrv \
	-Dc_args="$profile" -Dcpp_args="$profile" $repl $others -Dgallium-vdpau=$va -Dgallium-va=$va -Dvideo-codecs=$videocodecs ${EXTRA_OPTIONS}
