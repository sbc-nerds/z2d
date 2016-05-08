#!/bin/bash
. ./common-functions.sh
. ./system-settings.sh

debootstrap/debootstrap --second-stage

c_locale_debian ${LOCALES}
c_tzone ${TIMEZONE}
c_hostname ${C1_HOSTNAME}
c_apt_list_debian "jessie"
c_nameserver_modern ${NAMESERVERS}

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl
export DEBIAN_FRONTEND=noninteractive

r_pkg_upgrade

i_base_debian
i_extra
i_gcc_debian
i_kernel_odroid_c1

c_if_lo
c_if_dhcp "eth0"
c_ttyS_debian "ttyS0"
c_fw_utils "/dev/mmcblk0 0x80000 0x8000"
c_user ${USERNAME} ${PASSWORD}

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
