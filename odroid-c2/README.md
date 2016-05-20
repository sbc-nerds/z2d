This is the scripts for building Ubuntu 16.04 Minimal Image or Debian 8 Jessie Minimal Image for the ODROID C2. Also, you can install Docker.

## How to build Odroid-C2 UBUNTU 16.04 Minimal Image

The main goal of this installation is that it can be easily fit on 2Gb microSD card. It's a perfect installation for server nodes or a basic Linux installation without the desktop part.

All you need to do is follow these steps: 

* Change variables in `system-settings.sh`. You may want to change `USERNAME`, `PASSWORD` and `TIMEZONE`.
* Install dependencies: `apt-get install git curl dosfstools qemu-user-static`.
* Run the build script `sh ubuntu-core-00.sh`
* Pay attention to the screen and watch for issues. Answer the password prompt if needed.

As a result, you'll get Odroid-C2 Ubuntu 16.04 Minimal Image in the current directory named `odroid-c2-ubuntu-core.img`. Just flash it on your SD or EMMC card and have fun!