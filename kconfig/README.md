# Kconfig for yocto genericarm64

## Fragments

### output .configs
* ross-v1.config
  * result from using following yocto-kernel-cache
  * url: https://gitlab.com/rossburton/yocto-kernel-cache
  * commit 0c44cfe68aa8169c1e6c860c2ab1ae0e865e44f2
* ross-v2.config
  * result from using following yocto-kernel-cache
  * url: https://gitlab.com/rossburton/yocto-kernel-cache
  * commit 03628b9a0e6739ee8a210c8e90921ac68823eb3f
* config-6.6.20-defconfig
  * result from using upstream v6.6.20 defconfig

### kv260 config fragments
* zynqmp-ross.config
  * Things needed by zynqmp already in ross-v2
* zynqmp-defconfig.config
  * Things needed by zynqmp already in defconfig but not ross-v2
* zynqmp-new.config
  * new configs needed. Not in ross-v2 nor defconfig

### WIP kv260 config fragments (shotgun turn everything related on)
* zynqmp-sound.config
  * Attempt to enable sound
* zynqmp-v4l2.config
  * Attempt to enable video input/output/decode
* zynqmp-broken.config
  * Things that don't work in v6.6, see comments

## patches

* One patch to hack the Kconfig to allow CADENCE_TTC_TIMER to be enabled.
Although this patch (and zynqmp-broken.config) got the timer driver enabled,
the pwm-fan probe still did not complete.

## Compare Ross v2 to Upstream 6.6.20 defconfig

* Setup
  * clone upstream stable kernel and checkout v6.6.20
  * do any local build prep needed (env vars, cross complie setup, etc)
  * set YGA_DIR to the checkout of this repo
  ```
  $ cp $YGA_DIR/kconfig/*.config ./arch/arm64/configs
  ```
* ross-v2-not-achieved.txt
  * Things in ross-v2 that don't match when using w/ stock upstream 6.6.20
  * These are extra features in linux-yocto not upstream
  * You should ignore toolchain diffs
  ```
  $ make allnoconfig ross-v2.config
  $ $YGA_DIR/kconfig-compare arch/arm64/configs/ross-v2.config
  ```
* compare ross-v2 to defconfig
  ```
  $ make allnoconfig ross-v2.config
  $ $YGA_DIR/kconfig-compare arch/arm64/configs/defconfig
  ```
  * filter output into following
  * got-m-instead-of-y.txt
    * Things that are =y in defconfig but =m in ross-v2
    * OK as agreed strategy
  * got-y-instead-of-m.txt
    * Things that are =m in defconfig but =y in ross-v2
  * other-mismatch.txt
    * any other mis-match
  * missing.txt
    * Things in defconfig that are not in ross-v2
* compare defconfig to ross-v2
  ```
  $ make defconfig
  $ $YGA_DIR/kconfig-compare arch/arm64/configs/ross-v2.config
  ```
  * filter w/ grep MISSING to get
  * added.txt
    * Things in ross-v2 that are not in defconfig
  * other-mismatch2.txt
    * ignore m/y mismatch and capture all others
    * you should ignore toolchain and version differences
