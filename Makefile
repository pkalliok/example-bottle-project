
all:

# NB! unlike other targets, this is not meant to be run in your
# development environment.
# Run this on your workstation if you want to setup a development
# environment on a virtual host (Debian Jessie 8).
virtualbox-setup:
	sudo yum localinstall http://download.virtualbox.org/virtualbox/5.0.2/VirtualBox-5.0-5.0.2_102096_el6-1.x86_64.rpm
	wget http://ftp.funet.fi/pub/linux/mirrors/debian-cdimage/8.1.0/i386/iso-cd/debian-8.1.0-i386-CD-1.iso

sudo-setup:
	su -c "apt-get install sudo && usermod -a -G sudo `whoami`"
	touch sudo-setup

# Install 
devenv-setup: sudo-setup
	sudo apt-get install vim ctags make git
	sudo update-alternatives --set editor /usr/bin/vim.basic
	touch devenv-setup

docker-setup: sudo-setup
	sudo apt-get install docker.io debootstrap
	sudo usermod -a -G docker `whoami`
	sudo /usr/share/docker.io/contrib/mkimage.sh \
	-t `whoami`/debian-stable-minimal debootstrap --variant=minbase stable
	touch docker-setup

