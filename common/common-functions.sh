#!/bin/sh

c_locale () {
  for s in $@; do
    locale-gen $s
  done
  export LC_ALL="$1"
  update-locale LC_ALL="$1" LANG="$1" LC_MESSAGES=POSIX
  dpkg-reconfigure -f noninteractive locales
}

c_locale_debian () {
  for ((i = 1; i <= $#; i++)); do
    if (($i == 1)); then
      echo "${!i} UTF-8" > /etc/locale.gen
    else
      echo "${!i} UTF-8" >> /etc/locale.gen
    fi
  done
  locale-gen
  debconf-set-selections <<< "locales locales/default_environment_locale select $1"
  dpkg-reconfigure -f noninteractive locales
}


c_tzone () {
  echo "$1" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
}


c_hostname () {
  echo $1 > /etc/hostname
  echo "127.0.0.1       $1 localhost" >> /etc/hosts
}

c_apt_list () {
  echo "deb http://ports.ubuntu.com/ ${1} main restricted universe multiverse" > /etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ ${1}-security main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ ${1}-updates main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ ${1}-backports main restricted universe multiverse" >> /etc/apt/sources.list
}

c_apt_list_debian () {
  echo "deb http://ftp.debian.org/debian/ ${1} main contrib non-free" > /etc/apt/sources.list
  echo "deb http://ftp.debian.org/debian/ ${1}-updates main contrib non-free" >> /etc/apt/sources.list
  echo "deb http://ftp.debian.org/debian/ ${1}-backports main contrib non-free" >> /etc/apt/sources.list
  echo "deb http://security.debian.org/ ${1}/updates main contrib non-free" >> /etc/apt/sources.list

  echo "APT::Default-Release \"${1}\";" > /etc/apt/apt.conf.d/99defaultrelease

  echo "deb http://ftp.debian.org/debian/ stable main contrib non-free" > /etc/apt/sources.list.d/stable.list
  echo "deb http://security.debian.org/ stable/updates main contrib non-free" >> /etc/apt/sources.list.d/stable.list

  echo "deb http://ftp.debian.org/debian/ testing main contrib non-free" > /etc/apt/sources.list.d/testing.list
  echo "deb http://security.debian.org/ testing/updates main contrib non-free" >> /etc/apt/sources.list.d/testing.list
}

c_yum_list_f23_prim () {
  echo '[warning:fedora23]' >/etc/yum.repos.d/Fedora23Repo.repo
  echo 'name=fedora' >>/etc/yum.repos.d/Fedora23Repo.repo
  echo 'mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-23&arch=$basearch' >>/etc/yum.repos.d/Fedora23Repo.repo
  echo 'enabled=0' >>/etc/yum.repos.d/Fedora23Repo.repo
  echo 'gpgcheck=1' >>/etc/yum.repos.d/Fedora23Repo.repo
  echo 'gpgkey=https://getfedora.org/static/34EC9CBA.txt' >>/etc/yum.repos.d/Fedora23Repo.repo
}

c_yum_list_f23_second () {
  echo '[warning:fedora23]' >/etc/yum.repos.d/Fedora23Repo.repo
  echo 'name=fedora' >>/etc/yum.repos.d/Fedora23Repo.repo
  echo 'mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-23&arch=$basearch' >>/etc/yum.repos.d/Fedora23Repo.repo
  echo 'enabled=0' >>/etc/yum.repos.d/Fedora23Repo.repo
  echo 'gpgcheck=1' >>/etc/yum.repos.d/Fedora23Repo.repo
  echo 'gpgkey=https://getfedora.org/static/873529B8.txt' >>/etc/yum.repos.d/Fedora23Repo.repo
}

c_yum_list_f24_prim () {
  echo '[warning:fedora24]' >/etc/yum.repos.d/Fedora24Repo.repo
  echo 'name=fedora' >>/etc/yum.repos.d/Fedora24Repo.repo
  echo 'mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-24&arch=$basearch' >>/etc/yum.repos.d/Fedora24Repo.repo
  echo 'enabled=0' >>/etc/yum.repos.d/Fedora24Repo.repo
  echo 'gpgcheck=1' >>/etc/yum.repos.d/Fedora24Repo.repo
  echo 'gpgkey=https://getfedora.org/static/81B46521.txt' >>/etc/yum.repos.d/Fedora24Repo.repo
}

c_yum_list_f24_second () {
  echo '[warning:fedora24]' >/etc/yum.repos.d/Fedora24Repo.repo
  echo 'name=fedora' >>/etc/yum.repos.d/Fedora24Repo.repo
  echo 'mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-24&arch=$basearch' >>/etc/yum.repos.d/Fedora24Repo.repo
  echo 'enabled=0' >>/etc/yum.repos.d/Fedora24Repo.repo
  echo 'gpgcheck=1' >>/etc/yum.repos.d/Fedora24Repo.repo
  echo 'gpgkey=https://getfedora.org/static/030D5AED.txt' >>/etc/yum.repos.d/Fedora24Repo.repo
}

c_nameserver () {
  for ((i = 1; i <= $#; i++)); do
    if (($i == 1)); then
      echo "nameserver ${!i}" > /etc/resolv.conf
    else
      echo "nameserver ${!i}" >> /etc/resolv.conf
    fi
  done
}

r_pkg_upgrade () {
  apt-get -q=2 update
  apt-get -q=2 -y upgrade
  apt-get -q=2 -y dist-upgrade
}

i_base () {
  apt-get -q=2 -y install ubuntu-minimal software-properties-common curl u-boot-tools ssh linux-firmware vim
}

i_base_debian () {
  apt-get -q=2 -y install curl xz-utils u-boot-tools sudo openssh-server ntpdate ntp usbutils pciutils less lsof most sysfsutils ntfs-3g exfat-utils exfat-fuse firmware-linux
}

i_extra () {
  apt-get -q=2 -y install dialog screen wireless-tools iw libncurses5-dev cpufrequtils rcs aptitude make bc lzop man-db ntp usbutils pciutils lsof most sysfsutils
}

i_gcc () {
  apt-get -y install gcc-5 g++-5
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 50
}

i_gcc_debian () {
  apt-get -q=2 -y update
  apt-get -q=2 -y -t testing install gcc-5 g++-5
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 50
}

i_kernel_odroid_c1 () {
  apt-get -q=2 -y install initramfs-tools
# <HK quirk>
  echo "#!/bin/sh" > /etc/initramfs-tools/hooks/e2fsck.sh
  echo ". /usr/share/initramfs-tools/hook-functions" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/e2fsck /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck.ext4 /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  chmod +x /etc/initramfs-tools/hooks/e2fsck.sh
# </HK quirk>
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AB19BAC9
  echo "deb http://deb.odroid.in/c1/ trusty main" > /etc/apt/sources.list.d/odroid.list
  echo "deb http://deb.odroid.in/ trusty main" >> /etc/apt/sources.list.d/odroid.list
  apt-get -q=2 update
  mkdir -p /media/boot
  apt-get -q=2 -y install linux-image-3.10.80-142 linux-headers-3.10.80-142 bootini
# <HK quirk>
  cp /boot/uImage* /media/boot/uImage
# </HK quirk>
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c1/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s /media/boot/ kernel)
}

i_kernel_odroid_c2 () {
  apt-get -q=2 -y install initramfs-tools
# <HK quirk>
  echo "#!/bin/sh" > /etc/initramfs-tools/hooks/e2fsck.sh
  echo ". /usr/share/initramfs-tools/hook-functions" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/e2fsck /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck.ext4 /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  chmod +x /etc/initramfs-tools/hooks/e2fsck.sh
# </HK quirk>
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AB19BAC9
  echo "deb http://deb.odroid.in/c2/ xenial main" > /etc/apt/sources.list.d/odroid.list
  apt-get -q=2 update
  mkdir -p /media/boot
  apt-get -q=2 -y install linux-image-c2 bootini
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c2/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s /media/boot/ kernel)
}

i_kernel_odroid_c2_31429 () {
  curl -sSL https://www.dropbox.com/s/mh13gumm9xm2nb7/linux-3.14.29-c2.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c2/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-c2 kernel)
}


i_kernel_odroid_xu4 () {
  apt-get -q=2 -y install initramfs-tools
# <HK quirk>
  echo "#!/bin/sh" > /etc/initramfs-tools/hooks/e2fsck.sh
  echo ". /usr/share/initramfs-tools/hook-functions" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/e2fsck /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck.ext4 /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  chmod +x /etc/initramfs-tools/hooks/e2fsck.sh
# </HK quirk>
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AB19BAC9
  echo "deb http://deb.odroid.in/5422/ wily main" > /etc/apt/sources.list.d/odroid.list
  echo "deb http://deb.odroid.in/ wily main" >> /etc/apt/sources.list.d/odroid.list
  apt-get -q=2 update
  mkdir -p /media/boot
  apt-get -q=2 -y install linux-image-xu3 bootini
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-xu4/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s /media/boot/ kernel)
}

i_kernel_odroid_xu3_31096 () {
  curl -sSL https://www.dropbox.com/s/dq3txlc498i9c41/linux-3.10.96-xu3.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-xu4/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-xu3 kernel)
}

i_kernel_odroid_xu4_460 () {
  curl -sSL https://www.dropbox.com/s/hlp9kxpv29k91k6/linux-4.6.0-rc5%2B-xu4.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-xu4/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-xu4 kernel)
}

i_kernel_utilite_pro () {
  curl -sSL https://www.dropbox.com/s/374th8x274ptto6/linux-3.14.51%2B-upro.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
}

i_kernel_cubox_i () {
  curl -sSL https://www.dropbox.com/s/ydy7234qjctxazz/linux-4.6.0-rc5-dev-g1356441-cbihb.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/cubox-i/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-cbihb kernel)
}

i_kernel_pine64 () {
  curl -sSL https://www.dropbox.com/s/anqopy4bpsmdtmz/linux-3.10.65-7-pine64-p64.tar.xz?dl=0 | tar --numeric-owner -xhJpf -
  echo "8723bs" >> /etc/modules 
# U-571
  mkdir -p /boot/conf.d/system.default
  curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/pine64+/uEnv.txt > /boot/conf.d/system.default/uEnv.txt
  (cd /boot/conf.d/ ; ln -s system.default default)
  (cd /boot/conf.d/system.default; ln -s ../../kernel.d/linux-*-p64 kernel; ln -s kernel/Initrd Initrd )
}

c_if_lo () {
  echo "auto lo" > /etc/network/interfaces.d/lo
  echo "iface lo inet loopback" >> /etc/network/interfaces.d/lo
}

c_if_dhcp () {
  echo "auto $1" >/etc/network/interfaces.d/$1
  echo "iface $1 inet dhcp" >>/etc/network/interfaces.d/$1
}

c_ttyS () {
  echo "start on stopped rc or RUNLEVEL=[12345]" > /etc/init/${1}.conf
  echo "stop on runlevel [!12345]" >> /etc/init/${1}.conf
  echo "respawn" >> /etc/init/${1}.conf
  echo "exec /sbin/getty -L 115200 $1 vt102" >> /etc/init/${1}.conf
}

c_ttyS_debian () {
  echo T0:2345:respawn:/sbin/getty -L $1 115200 vt100 >> etc/inittab
}

c_fw_utils () {
  echo "$1" > /etc/fw_env.config
}

c_user () {
  adduser --gecos '' $1
  usermod -aG adm,cdrom,dialout,sudo,plugdev $1
}
