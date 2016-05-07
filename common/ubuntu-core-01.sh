#!/bin/bash
set -ex

curl -sSL http://cdimage.ubuntu.com/ubuntu-core/releases/16.04/release/ubuntu-core-16.04-core-armhf.tar.gz | sudo tar --numeric-owner -xpzf - -C rootfs/

sudo mount -o bind /dev ./rootfs/dev
sudo mount -o bind /dev/pts ./rootfs/dev/pts
sudo mount -t sysfs /sys ./rootfs/sys
sudo mount -t proc /proc ./rootfs/proc
sudo cp /proc/mounts ./rootfs/etc/mtab
sudo cp ubuntu-core-02.sh ./rootfs
sudo cp common-functions.sh ./rootfs
sudo cp system-settings.sh ./rootfs
sudo cp ubuntu-docker-00.sh ./rootfs

sudo mkdir -p ./rootfs/usr/bin
sudo cp /usr/bin/qemu-arm-static ./rootfs/usr/bin
sudo cp /usr/bin/qemu-aarch64-static ./rootfs/usr/bin

sudo chroot ./rootfs bash /ubuntu-core-02.sh
sudo rm ./rootfs/ubuntu-core-02.sh
sudo rm ./rootfs/common-functions.sh
sudo rm ./rootfs/usr/bin/qemu-arm-static
sudo rm ./rootfs/usr/bin/qemu-aarch64-static

sudo umount ./rootfs/dev/pts
sudo umount ./rootfs/sys
sudo umount -l ./rootfs/dev
sudo umount -l ./rootfs/proc
