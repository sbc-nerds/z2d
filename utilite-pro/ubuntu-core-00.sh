#!/bin/bash
. ./system-settings.sh

IS_IMAGE=false
if [ -z "${DEVICE}" ]; then
    IS_IMAGE=true
    IMAGE_PATH=$PWD/`basename \`dirname \\\`realpath "$0"\\\`\``-`basename -s -00.sh "$0"`.img
    cd `dirname \`realpath "$0"\``
    #dd if=/dev/zero of=${IMAGE_PATH} bs=1M count=1024
    sudo rm ${IMAGE_PATH}
    truncate -s 1024M ${IMAGE_PATH}
    DEVICE=`losetup -f`
    sudo losetup ${DEVICE} ${IMAGE_PATH}
fi

re='^[0-9]$'
if  [[ ${DEVICE: -1} =~ $re ]] ; then
    PARTITION_1="p1"
else
    PARTITION_1="1"
fi

/bin/echo -e "o\nn\np\n1\n2048\n\nw\n" | sudo fdisk ${DEVICE}
sync
sudo partprobe -s ${DEVICE}

sudo mkfs.ext4 -O ^has_journal -b 4096 -U deadbeef-dead-beef-dead-beefdeadbeef -L rootfs ${DEVICE}${PARTITION_1}
sudo mount ${DEVICE}${PARTITION_1} ./rootfs

if [ "$IS_IMAGE" = true ]; then
    sh ./`basename -s -00.sh "$0"`-01.sh
    sudo umount ./rootfs
    sync
    sudo losetup -d ${DEVICE}
    cd -
fi
