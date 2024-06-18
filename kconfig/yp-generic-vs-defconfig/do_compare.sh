#!/bin/sh

CMP=../../kconfig-compare
YP=../config-6.6.23-yp-5.0.1
DEF=../config-6.6.23-defconfig
DEFCONFIG=../defconfig-v6.6.23
UP_YP=../config-upstream-6.6.23-yp-5.0.1-config

FILE=defconfig-not-achieved.txt
echo "# compare defconfig to itself" >$FILE
echo "# these are things defconfig sets that remain off or different in output" >>$FILE
echo "" >>$FILE
$CMP $DEFCONFIG $DEF | grep -v OK >>$FILE

# now compare yocto project genericarm64 config to defconfig
$CMP --no-not-set $YP $DEF >yp-to-def.txt
$CMP --no-not-set $DEF $YP >def-to-yp.txt

FILE=added-to-yp.txt
echo "# find things added in yp not in defconfig" >$FILE
echo "" >>$FILE
grep -E "MISSING!|NOT SET!" yp-to-def.txt >>$FILE

FILE=got-y-instead-of-m.txt
echo "# find things changed from module in defconfig to yes in yp" >$FILE
echo "" >>$FILE
grep "got=y wanted=m" yp-to-def.txt >>$FILE

FILE=got-m-instead-of-y.txt
echo "# find things changed from yes in defconfig to module in yp" >$FILE
echo "" >>$FILE
grep "got=m wanted=y" yp-to-def.txt >>$FILE

FILE=missing-from-yp.txt
echo "# find things missing from yp config that are in defconfig" >$FILE
echo "" >>$FILE
grep -E "MISSING!|NOT SET!" def-to-yp.txt >>$FILE

FILE=other-mismatch.txt
echo "# find all other mismatches between yp and defconfig" >$FILE
echo "# (got=defconfig wanted=yp)" >>$FILE
echo "" >>$FILE
grep "MISMATCH got" yp-to-def.txt | \
    grep -v "got=m wanted=y" | grep -v "got=y wanted=m" >>$FILE

FILE=yp-upstream-not-achieved.txt
echo "# listing things in yp config that are not effective when used with stock kernel" >$FILE
echo "" >>$FILE
$CMP --no-not-set $YP $UP_YP | grep -v OK >>$FILE
