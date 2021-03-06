
.PHONY: development-setup

development-setup: stamps/docker-image-minimal stamps/devenv-setup

# stamps/git-setup
#stamps/git-setup: scripts/git-pre-push
	#ln -sf ../../scripts/git-pre-push .git/hooks/pre-push
	#touch $@

# rules for setting up the development environment

stamps/sudo-setup:
	su -c "apt-get install sudo"
	su -c "usermod -a -G sudo `whoami`"
	@echo "====> sudo set up!  But now you need to make a new login."
	touch $@

stamps/devenv-setup: stamps/sudo-setup
	sudo apt-get install vim ctags make git
	sudo update-alternatives --set editor /usr/bin/vim.basic
	touch $@

stamps/backports-setup: stamps/sudo-setup
	sudo bash -c "echo -e '\n# Jessie backports (for docker)\ndeb http://http.debian.net/debian jessie-backports main contrib non-free' >> /etc/apt/sources.list"
	sudo apt-get update
	touch $@

stamps/docker-setup: stamps/sudo-setup stamps/backports-setup
	sudo apt-get install docker.io debootstrap
	sudo usermod -a -G docker `whoami`
	@echo "====> docker set up!  But now you need to make a new login."
	touch $@

stamps/docker-image-minimal: stamps/sudo-setup stamps/docker-setup
	sudo /usr/share/docker.io/contrib/mkimage.sh \
	-t `whoami`/debian-stable-minimal debootstrap --variant=minbase stable
	touch $@

stamps/docker-image-%: dockerfiles/%.docker stamps/docker-image-minimal
	sed "s/%USER%/`whoami`/g" $< | \
	docker build --rm -t `whoami`/debian-stable-$* -
	touch $@

# rules for setting up a VirtualBox for the development environment
# NB! unlike other targets, this is not meant to be run in your
# development environment.
# Run this on your RHEL6 workstation if you want to setup a development
# environment on a virtual host (Debian Jessie 8).
DEVEL_HOST=testdevelhost-1
stamps/virtualbox-setup: debian-8.2.0-i386-CD-1.iso
	#sudo yum localinstall http://download.virtualbox.org/virtualbox/5.0.2/VirtualBox-5.0-5.0.2_102096_el6-1.x86_64.rpm
	vboxmanage createvm -name $(DEVEL_HOST) -register
	vboxmanage modifyvm $(DEVEL_HOST) --memory 768 --vram 64 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eth0 --ostype Debian
	vboxmanage createvdi --filename $(DEVEL_HOST)-disk01.vdi --size 8192 
	vboxmanage storagectl $(DEVEL_HOST) --name 'IDE Controller' --add ide
	vboxmanage modifyvm $(DEVEL_HOST) --boot1 dvd --hda $(DEVEL_HOST)-disk01.vdi --sata on
	vboxmanage storageattach $(DEVEL_HOST) --storagectl 'IDE Controller' --port 0 --device 0 --type hdd --medium $(DEVEL_HOST)-disk01.vdi 
	vboxmanage storageattach $(DEVEL_HOST) --storagectl 'IDE Controller' --port 1 --device 0 --type dvddrive --medium debian-8.2.0-i386-CD-1.iso
	vboxmanage modifyvm $(DEVEL_HOST) --dvd debian-8.2.0-i386-CD-1.iso
	vboxmanage startvm $(DEVEL_HOST)
	touch $@

debian-8.2.0-i386-CD-1.iso:
	wget http://trumpetti.atm.tut.fi/debian-cd/8.2.0/i386/iso-cd/debian-8.2.0-i386-CD-1.iso

