#!/bin/bash

prefix=${PREFIX:-/usr/local}

if test x$1 = x32; then
    # 32-bit build
    rm -rf build32

    set -e

    mkdir build32
    cd build32
    export CC=i686-linux-gnu-gcc
    export CXX=i686-linux-gnu-g++
    cmake ../llvm -G Ninja \
        -DCMAKE_INSTALL_PREFIX=$prefix/llvm-i386 -DLLVM_TARGETS_TO_BUILD="X86;AMDGPU" -DLLVM_ENABLE_ASSERTIONS=ON \
        -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_LINK_LLVM_DYLIB=ON -DLLVM_APPEND_VC_REV=OFF \
        -DLLVM_BUILD_32_BITS=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_CCACHE_BUILD=ON -DLLVM_ENABLE_LIBXML2=OFF \
        -DCMAKE_C_FLAGS_RELEASE="-O2 -g1 -fno-omit-frame-pointer" \
        -DCMAKE_CXX_FLAGS_RELEASE="-O2 -g1 -fno-omit-frame-pointer"

    echo -e "[binaries]\nllvm-config = '$prefix/llvm-i386/bin/llvm-config'\n" > `dirname $0`/llvm_config_i386-linux-gnu.cfg
else
    # 64-bit build
    rm -rf build

    set -e

    mkdir build
    cd build

    cmake ../llvm -G Ninja \
        -DCMAKE_INSTALL_PREFIX=$prefix/llvm-x86_64 -DLLVM_TARGETS_TO_BUILD="X86;AMDGPU" -DLLVM_ENABLE_ASSERTIONS=ON \
        -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_LINK_LLVM_DYLIB=ON -DLLVM_APPEND_VC_REV=OFF \
        -DLLVM_CCACHE_BUILD=ON -DLLVM_ENABLE_RTTI=ON \
        -DCMAKE_C_FLAGS_RELEASE="-O2 -g1 -fno-omit-frame-pointer" \
        -DCMAKE_CXX_FLAGS_RELEASE="-O2 -g1 -fno-omit-frame-pointer"


    echo -e "[binaries]\nllvm-config = '$prefix/llvm-x86_64/bin/llvm-config'\n" > `dirname $0`/llvm_config_x86_64-linux-gnu.cfg
fi

cd ..
