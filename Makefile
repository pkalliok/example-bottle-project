
all:

docker-setup:
	sudo apt-get install docker.io debootstrap
	sudo usermod -a -G docker `whoami`
	sudo /usr/share/docker.io/contrib/mkimage.sh \
	-t `whoami`/debian-stable-minimal debootstrap --variant=minbase stable

