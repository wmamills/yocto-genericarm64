#!/bin/bash

echo "pre-build for PWD=$PWD"
if [ -d build ]; then
    cd build
    DATE=$(date +%Y-%m-%d-%H-%M-%S)

    if [ -d tmp ]; then
        mv tmp tmp-${DATE}
    fi

    if [ -d downloads ]; then
        D=downloads-${DATE}
        mkdir -p $D/git2
        cd downloads
        # move whole directories first, then everything else
        find -type d -name "*wmamills*" | xargs -n 1 -I '{}' mv '{}' ../$D/'{}'
        find -name "*wmamills*" | xargs -n 1 -I '{}' mv '{}'  ../$D/'{}'
    fi
else
    echo "no build dir"
fi
