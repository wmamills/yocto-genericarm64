#!/bin/bash

# Nothing to do on remote side of remote build
if [ x"$CONTEXT" == x"remote" ]; then
    exit 0
fi

# if we don't have an FTP deploy dir, then nothing to do
if [ x"$DEPLOY_TFTP_DIR" == x"" ]; then
    exit 0
fi

M=genericarm64
L=build-${M}-latest
LINK=$(readlink $L)
D=$DEPLOY_TFTP_DIR

echo "Deploy $L ($LINK) to $D"

mkdir -p $D
rm -rf $D/Image*
rm -rf $D/modules*.tgz
rm -rf $D/*.rootfs*.tar.gz
rm -rf $D/kernel-dev*.{rpm,ipk}
cp -a $L/deploy/images/${M}/Image* $D/
cp -a $L/deploy/images/${M}/modules*.tgz $D/
cp -a $L/deploy/images/${M}/*.rootfs*.tar.gz $D/
cp -a $L/deploy/rpm/${M}/kernel-dev*.ipk $D/ || true
cp -a $L/deploy/rpm/${M}/kernel-dev*.rpm $D/ || true
echo $LINK >$D/info.txt
make-image-targets $D
echo "Deploy done $L ($LINK) to $D"
