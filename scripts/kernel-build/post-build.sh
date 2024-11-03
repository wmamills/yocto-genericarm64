#!/bin/bash

echo "post-build for PWD=$PWD CONTEXT=$CONTEXT"

# Nothing to do on remote side of remote build
if [ x"$CONTEXT" == x"remote" ]; then
    exit 0
fi

# if we don't have an TFTP deploy dir, then nothing to do
if [ x"$DEPLOY_TFTP_DIR_BASE" == x"" ]; then
    exit 0
fi

M=$(basename $BUILD_CONFIG)
L=$INSTALL_PATH_BASE
LINK=$(readlink $L)

PRJ=genericarm64

case $BUILD_CONFIG_FLAT in
"kv260"|"aarch64")
    BOARD=kv260
    IMAGE=Image
    ;;
"stmp1"|"armv7")
    BOARD=stmp1
    IMAGE=zImage
    ;;
*)
    echo "Unknown config $BUILD_CONFIG_FLAT, skipping deploy"
    exit
esac

D=$DEPLOY_TFTP_DIR_BASE/${BOARD}-${PRJ}/k-${SUBPRJ}-latest

echo "Deploy $L ($LINK) to $D"

shopt -s nullglob

rm -rf $D/*
mkdir -p $D
mkdir -p $D/dtb
for f in $L/boot/*; do
    if [ -d $f ]; then
        cp -a $f $D/dtb/ 
    elif [ -e $f ]; then
        cp -a $f $D/ 
    fi
done
cp -a $L/modules-*.tar.gz $D/
ln -sf $(basename $D/vmlinuz*) $D/$IMAGE
ln -sf ../make-targets-helper-kernel-build $D/make-targets-helper
echo "Deploy $LINK on $(date)" >$D/info.txt
make-image-targets $D
echo "Deploy done $L ($LINK) to $D"

