# Work in progress for Yocto Project genericarm64

This is the kas build manifest for my work in progress for Yocto Projects's
genericarm64 machine support.

It is primarily aimed at support of AMD Xilinx kv260 board which is one of the
selected reference boards and is based on the ZynqMP SOC family.  Some testing
of the other reference board, TI AM62x SOC based BeaglePlay from
beagleboard.org, is also done.

To use, setup for Yocto Project and kas, and then run:
```
$ kas build genericarm64.yml
```

This project also has a top level manifest for qemuarm64.yml for comparison
purposes.

The manifests are setup to pull by my wam-wip branch of my repo of poky.  This
branch contains:
* Upstream baseline including support for basic genericarm64
* Extra commits from Ross Burton that are pending for upstream
* One patch to get yocto-kernel-cache from my wam-wip branch of my repo
and to autorev from that branch

The yocto-kernel-cache wam-wip branch contains:
* Upsteam master
* Pending changes from Ross
* Pending changed from me

## Other directories

### kconfig/

This directory contains Kconfig fragments to be used with the upstream kernel
and comparisons between the Yocto Project genericarm64 kernel .config and the
upstream defconfig.

See the README.md in that directory.

### dtb/

Contains a patch against upstream v6.6 that modifies kv260 dts so that it will
work with the zynqmp display support in v6.6.  This patch is not integrated
with the Yocto layers as DTB is a firmware issue not an OS one.

### .prjinfo/ and scripts/

These directories support my work flow and are based on other tools I make and
use.

The example setting file in .prjinfo shows how I setup my remote-build script
to work with this project.  It also uses the pre- and post- build scripts in
the scripts directory.  The remote-build script does a build on a different
machine and then uses oe-results to sync the output back.

The pre-build.sh script currently renames the build/tmp directory and moves any
git download copy for build/downloads.  I found this necessary for working with
a yocto-kernel-cache that was rebasing.  It may be overkill but it works.

The post-build.sh script deploys the most recent build to my TFTP directories
and creates the initrd.cpio.gz.  It does nothing unless DEPLOY_TFTP_DIR is
defined.

remote-build is one of the tools in a family of tools I call prjtools and all
use the .prjinfo directory for settings and other configuration.
.prjinfo/local is automatically added to the .git/exclude file and is used for
temporary files and local configuration that should not be recorded in git.

remote-build, oe-results and a couple of other tools are here:
https://github.com/wmamills/cloudbuild

### tftp/

These are the assets I use in my tftp directory.  These builds have been tested
with full SD card images but for quick turn around I normally use TFTP.

To do this I arrange for the board to do DHCP when it boots and then boot
whatever file the DHCP server says.  For kv260 I use an SD card with a VFAT
partition with a single boot.scr file on it.

The DHCP server recognizes the MAC address of the kv260 and gives it a
consistent IP address and tells it to boot /kv260/uEnv.txt which in turn will
be a symlink to the uEnv.txt I am currently working with.

The uEnv.txt I use with this project is recorded here.  It allows me to quickly
switch between baselines and the current latest build.  It also lets me choose
which DTB to boot with, either a specific one or the one from the boot firmware.

The defconfig, k-genericarm64-v3 and the yp-genericarm64-latest show three
configurations that I boot.  All of these directories use another tool of mine
to build the initrd.cpio.rd file to use for booting.  This tool is called
make-image-targets and is currently bundled into a project but is standalone.
This tool uses a "helper" script in each project to specify what to build.  The
helper scripts I use with this project are in the /tftp directory.

make-image-targets can be found here:
https://github.com/wmamills/openamp-demo/blob/main/qemu-zcu102/bin/make-image-targets

The defconfig shows how I deploy a kernel I build myself from the kernel
makefile.  I deploy the kernel image and a modules tar file.  The
make-image-targets run will start with a simple common rootfs and add the
current modules and any extra files I put in the specified directories.

The yp-genericarm64-latest directory show using the output of a the kas build
more directly.  The rootfs is used directly from the -latest directory and the
modules are used as is.
