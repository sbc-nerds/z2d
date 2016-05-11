#!/bin/bash
set -ex
. ./system-settings.sh

IS_IMAGE=false
if [ -z "${DEVICE}" ]; then
    IS_IMAGE=true
    IMAGE_PATH=$PWD/`basename \`dirname \\\`realpath "$0"\\\`\``-`basename -s -00.sh "$0"`.img
    cd `dirname \`realpath "$0"\``
    #dd if=/dev/zero of=${IMAGE_PATH} bs=1M count=1024
    sudo rm -f ${IMAGE_PATH}
    truncate -s 2048M ${IMAGE_PATH}
    DEVICE=`losetup -f`
    sudo losetup ${DEVICE} ${IMAGE_PATH}
fi

re='^[0-9]$'
if  [[ ${DEVICE: -1} =~ $re ]] ; then
    PARTITION_1="p1"
    PARTITION_2="p2"
else
    PARTITION_1="1"
    PARTITION_2="2"
fi

curl -sSL https://www.stdin.xyz/downloads/people/longsleep/pine64-images/simpleimage-pine64-latest.img.xz | unxz | sudo dd of=${DEVICE}
sync
set +e
/bin/echo -e "d\n2\nn\np\n2\n143360\n\nw\n" | sudo fdisk ${DEVICE}
set -e
sync
sudo partprobe -s ${DEVICE}

sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef ${DEVICE}${PARTITION_2}
sudo mount ${DEVICE}${PARTITION_2} ./rootfs

sudo mkdir ./rootfs/bootenv
sudo mount ${DEVICE}${PARTITION_1} ./rootfs/bootenv
sudo rm -rf rootfs/bootenv/initrd.img rootfs/bootenv/pine64/
curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/pine64+/bundle.uEnv | sudo dd of=./rootfs/bootenv/bundle.uEnv
curl -sSL https://github.com/umiddelb/u-571/blob/master/board/pine64+/uboot.env.xz?raw=true | unxz | sudo dd of=./rootfs/bootenv/uboot.env

if [ "$IS_IMAGE" = true ]; then
    sh ./`basename -s -00.sh "$0"`-01.sh
    sudo umount ./rootfs/bootenv
    sudo umount ./rootfs
    sync
    sudo losetup -d ${DEVICE}
    cd -
fi
