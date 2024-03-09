#!/bin/bash

DATE=$(date +%Y-%m-%d-%H-%M-%S)
D=downloads-${DATE}
cd build
mv tmp tmp-${DATE}
mkdir -p $D
cd downloads
find -name "*wmamills*" | xargs -n 1 -I '{}' mv '{}' ./$D/
