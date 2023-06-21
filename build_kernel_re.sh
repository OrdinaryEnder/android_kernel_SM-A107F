#!/bin/bash

# export CROSS_COMPILE=$(pwd)/toolchains/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
# export CC=$(pwd)/toolchains/clang-r428724/bin/clang
# export CLANG_TRIPLE=aarch64-linux-gnu-
# export ARCH=arm64

if [ -d include/config ]; then
    echo "Find config,will remove it"
    rm -rf include/config
else
    echo "No Config,good."
fi

# I use Proton-Clang
export PATH=$PATH:$(pwd)/proton-clang/bin/
export CC=clang
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

export ARCH=arm64
export SUBARCH=arm64
export ANDROID_MAJOR_VERSION=r

export KCFLAGS=-w
# export CONFIG_SECTION_MISMATCH_WARN_ONLY=y

date="$(date +%Y.%m.%d-%I:%M)"

make O=out KCFLAGS=-w ARCH=arm64 CC=clang a10s_defconfig
make O=out KCFLAGS=-w ARCH=arm64 CC=clang -j24 2>&1 | tee kernel_log-${date}.txt

if [ -f out/arch/arm64/boot/Image.gz ]; then
    echo " "
    echo "Copy Image.gz"
    cp out/arch/arm64/boot/Image.gz Image.gz
    echo " "
    echo "***Sucessfully built kernel...***"
    echo " "
    exit 0
else
    echo " "
    echo "***Failed!***"
    exit 0
fi
