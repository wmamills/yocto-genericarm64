# How to update the boot firmware on Beagleplay

* Download a emmc flasher from Beagleboard.org such as this one:
  * https://files.beagle.cc/file/beagleboard-public-2021/images/beagleplay-emmc-flasher-debian-12.2-minimal-arm64-2023-10-07-6gb.img.xz

* write it to SD card in the normal fashion

* remount the SD card's 2 partitions
  * eject sd from host and reinsert it
  * mount both partitions

* download the replacement boot firmware files from here:
  * https://people.linaro.org/~bill.mills/genericarm64/play-firmware/beagleplay-boot-files.tar.gz

* You must replace 3 files with the versions from the tar file's deploy/ dir.
  ```
    tiboot3.bin
    tispl.bin
    u-boot.img
  ```

  * You must do this in 2 places

  * In this example the two sd card partitions are mounted as
    ```
           /media/sde1   1st partition aka BOOT
      and  /media/sde2   2nd partition aka rootfs
    ```

  * The following sequence of commands would do the update

  ```
  $ rm -rf deploy
  $ tar xvzf beagleplay-boot-files.tar.gz
  $ sudo cp deploy/* /media/sde1/
  $ sudo cp deploy/* /media/sde2/opt/u-boot/bb-u-boot-beagleplay/
  ```

  * Each of these copy operations should overwrite 3 files with the new ones.

* sync; unmount; and eject the sd card from the host

* Hold the USR button on the Beagleplay while applying power
  * Verfiy that the new U-boot messages are present
  * (This is not strictly required but verifies you can boot from SD before
  updating the emmc)

* Allow the SD card to continue to boot its default option and it will update
  the emmc with the new boot files AND the distro on the SD card.

* Wait for the "knight rider / cylon " LEDs to stop flashing

* Power down the board

* Wait at least 10 seconds!
  * (I initially skipped this step and scared myself)

* Power up the board without the sd card and without the USR button

* Verify the new U-boot messages are present.

* As of 2024/03/07 the "new" versions you should see are:
  ```
  U-Boot SPL 2024.04-rc3-00066-g485bfe1adbb (Mar 06 2024 - 16:28:36 -0600)
  SYSFW ABI: 3.1 (firmware rev 0x0009 '9.2.5--v09.02.05 (Kool Koala)')
  NOTICE:  BL31: v2.10.0(debug):v2.10.0-541-g4a8357fb4
  I/TC: OP-TEE version: 4.1.0-190-gf5305d4dd (gcc version 11.2.1 20220111 (GNU Toolchain for the Arm Architecture 11.2-2022.02 (arm-11.14))) #1 Wed Mar  6 22:25:42 UTC 2024 aarch64
  U-Boot SPL 2024.04-rc3-00066-g485bfe1adbb (Mar 06 2024 - 16:28:48 -0600)
  U-Boot 2024.04-rc3-00066-g485bfe1adbb (Mar 06 2024 - 16:28:48 -0600)
  ```