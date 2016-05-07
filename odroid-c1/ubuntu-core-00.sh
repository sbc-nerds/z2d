#!/bin/sh
. ./system-settings.sh

IS_IMAGE=false
if [ -z "${DEVICE}" ]; then
    IS_IMAGE=true
    IMAGE_NAME=$PWD/`basename \`dirname \\\`realpath "$0"\\\`\``-`basename -s -00.sh "$0"`.img
    cd `dirname \`realpath "$0"\``
    dd if=/dev/zero of=${IMAGE_NAME} bs=1M count=1024
    sudo losetup /dev/loop0 ${IMAGE_NAME}
    DEVICE=`losetup -f`
fi

re='^[0-9]$'
if  [[ ${DEVICE: -1} =~ $re ]] ; then
    PARTITION_1="p1"
else
    PARTITION_1="1"
fi

/bin/echo -e "o\nn\np\n1\n3072\n\nw\n" | sudo fdisk ${DEVICE}
sync
sudo partprobe -s ${DEVICE}

curl -sSL https://raw.githubusercontent.com/mdrjr/c1_uboot_binaries/master/bl1.bin.hardkernel > /tmp/bl1.bin.hardkernel
curl -sSL https://raw.githubusercontent.com/mdrjr/c1_uboot_binaries/master/u-boot.bin > /tmp/u-boot.bin
sudo dd if=/tmp/bl1.bin.hardkernel of=${DEVICE} bs=1 count=442
sudo dd if=/tmp/bl1.bin.hardkernel of=${DEVICE} bs=512 skip=1 seek=1
sudo dd if=/tmp/u-boot.bin of=${DEVICE} bs=512 seek=64
rm -f /tmp/bl1.bin.hardkernel /tmp/u-boot.bin
sync

curl -sSL https://github.com/umiddelb/u-571/raw/master/uboot-env > uboot-env
chmod +x uboot-env
sudo ./uboot-env -d ${DEVICE} -o 0x80000 -l 0x8000 del -I
sudo ./uboot-env -d ${DEVICE} -o 0x80000 -l 0x8000 del -i
curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c1/bundle.uEnv | sudo ./uboot-env -d ${DEVICE} -o 0x80000 -l 0x8000 set
sync

sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef ${DEVICE}${PARTITION_1}
sudo mount ${DEVICE}${PARTITION_1} ./rootfs

if [ "$IS_IMAGE" = true ]; then
    sh ./`basename -s -00.sh "$0"`-01.sh
    sudo umount ./rootfs
    sync
    sudo losetup -d ${DEVICE}
    cd -
fi
