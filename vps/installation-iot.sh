#!/bin/sh

region="Europe"
city="Zurich"

myhostame="iot"
mypw="1234"
myuser="iot"

GATEWAY="198.168.1.1"
IP_ADDRESS="198.168.1.2/24"
INTERFACE="eno1"

MNT="/mnt"

network_setting() {
	IP_SH=${MNT}"/usr/bin/ip.sh"
	IP_SERVICE=${MNT}"/lib/systemd/system/ip.service"
	RESOLV_CONF=${MNT}"/etc/resolv.conf"

	cat <<- eof > ${IP_SH}
	#!/bin/bash

	ip address add ${IP_ADDRESS} broadcast + dev ${INTERFACE}
	ip link set ${INTERFACE} up
	ip route add default via ${GATEWAY} dev ${INTERFACE}

	# ip route add default via ${GATEWAY}
	eof

	chmod +x ${IP_SH}

	cat <<- eof > ${IP_SERVICE}
	[Unit]
	Description=My network configuration

	[Service]
	ExecStart=/usr/bin/ip.sh

	[Install]
	WantedBy=multi-user.target
	eof

	cat <<- eof > ${RESOLV_CONF}
	# Resolver configuration file.
	# See resolv.conf(5) for details.
	eof
}

partition_the_disk () {
	gdisk /dev/sda <<- eof
	o
	y
	n


	+42Mib
	ef00
	n


	+420Mib
	ef00
	n


	+16Gib
	8200
	n



	8300
	w
	y
	eof
}

format_the_partitions () {
	mkfs.fat -n THE_EFI -F 32 /dev/sda1
	mkfs.fat -n THE_BOOT -F 32 /dev/sda2
	mkswap -L THE_SWAP /dev/sda3
	mkfs.ext4 -L THE_ROOT /dev/sda4
}

mount_the_file_systems () {
	mount /dev/sda4 /mnt
	mount --mkdir /dev/sda2 /mnt/boot
	mount --mkdir /dev/sda1 /mnt/boot/efi
	mount --mkdir /dev/MyVolGroup/home /mnt/home
	swapon /dev/sda3
}

install_essential_packages () {
	pac="base"
	pac="$pac base-devel"
	pac="$pac linux"
	pac="$pac linux-firmware"

	pac="$pac dosfstools"
	pac="$pac e2fsprogs"

	pac="$pac grub"
	pac="$pac efibootmgr"

	pac="$pac git"
	pac="$pac vim"
	pac="$pac zsh"
	pac="$pac tmux"
	pac="$pac tree"
	pac="$pac neofetch"
	pac="$pac openssh"

	pacstrap /mnt $pac
}

fstab () {
	genfstab -U /mnt >> /mnt/etc/fstab
}

chroot () {
	arch-chroot /mnt <<- eof
	ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime
	hwclock --systohc

	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
	locale-gen
	echo "LANG=en_US.UTF-8" > /etc/locale.conf

	echo $myhostame > /etc/hostname

	groupadd sudo
	useradd -m $myuser
	usermod -aG sudo $myuser

	yes $mypw | passwd
	yes $mypw | passwd $myuser

	echo "s/#\s%sudo\sALL=(ALL:ALL)\sALL/  %sudo ALL=(ALL:ALL) ALL/" | EDITOR='sed -f- -i' visudo
	eof
}

bootloader_grub () {
	cp /mnt/etc/default/grub grub.bk
	arch-chroot /mnt <<< \
	"grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB"

	arch-chroot /mnt <<< \
	"grub-mkconfig -o /boot/grub/grub.cfg"
}

bootloader_mkinit () {
	cp /mnt/etc/default/mkinitcpio.conf mkinitcpio.conf.bk

	arch-chroot /mnt <<< "mkinitcpio -P"
}

enable_services () {
	arch-chroot /mnt <<- eof
	systemctl enable sshd
	systemctl enable ip.service
	eof
}

main () {
	# TIME ON
	timedatectl set-ntp true

	partition_the_disk
	format_the_partitions
	mount_the_file_systems
	install_essential_packages
	fstab
	chroot
	bootloader_grub
	bootloader_mkinit
	network_setting
	enable_services
}

if ! cat /sys/firmware/efi/fw_platform_size
then
	echo "not uefi !!!"
	exit 1
fi

main
