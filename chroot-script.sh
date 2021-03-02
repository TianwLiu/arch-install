#!/bin/bash

#arch-chroot

mkdir -p /mnt/root/arch-install

cp config /mnt/root/arch-install/env
printf "\nbootmode=%s\n" $bootmode >> /mnt/root/arch-install/env


printf "arch-chroot ... "
arch-chroot /mnt /bin/bash <<"EOT"
source /root/arch-install/env
printf "ok\n"

mkdir -p /root/arch-install

#Set Timezone
printf "timedatectl set-timezone $timezone ... "
timedatectl set-timezone $timezone > /root/arch-install/timedatectl.log
printf "ok\n"

printf "hwclock --systohc ... "
hwclock --systohc > /root/arch-install/hwclock.log
printf "ok\n"

#Localiztion
#generate locale
printf "\n#added by arch-install.sh\nen_US.UTF-8 UTF-8\n" >> /etc/locale.gen
locale-gen > /root/arch-install/locale-gen.log
#set system locale
printf "LANG=en_US.UTF-8" > /etc/locale.conf





#Network configuration
printf "Set hostname and localhost ... "

printf "$hostname" > /etc/hostname

printf "\n#added by arch-install.sh\n" >> /etc/hosts
printf "127.0.0.1	localhost\n" >> /etc/hosts
printf "::1		localhost\n" >> /etc/hosts
printf "127.0.1.1	$hostname.localdomain	$hostname">> /etc/hosts

printf "ok\n"

#set network for using pacman
#interfaces=`ls /sys/class/net`
#for interface in ${interfaces[@]};do
#	ip link set $interface up
#done
#if [[ -e /etc/resolv.conf ]];then
#	mv /etc/resolv.conf /etc/resolv.conf.bak-by-arch-install
#fi
#printf "#added by arch-install.sh\n" >> /etc/resolv.conf
#printf "nameserver	8.8.8.8\n" >> /etc/resolv.conf
#



#Install Custom Packages
#printf "Installing Custom Packages, Ctrl +C to cancel\n"
#printf "Executing in 3 seconds "
#for i in {1..3};do
#	sleep 1
#	printf ". "
#done	
#printf "\n"
#
#printf "pacman -Syu\n"
#pacman -Syu 2>>/root/arch-install-package.error.log || exit 0
#
#
#printf "Packages failed to install:\n" >> /root/arch-install-package.error.log
#for package in ${packages[@]};do
#	echo $package
#	pacman -S $package 2>>/root/arch-install-package.error.log || exit 0 
#	#if [[ !$? ]];then
#	#	printf "$package\n" >> /root/arch-install.log
#	#fi
#done
#


#Initramfs
if [[ $online == false ]];then
	printf "mkinitcpio -P ... "
	mkinitcpio -P > /root/arch-install/mkinitcpio.log 2>&1
	printf "ok\n"
fi




#Set Boot loader
#printf "Please set boot loader by yourself. You can set up via GRUG which may have been installed\n"
printf "Installing bootloader ... \n"
if [[ $bootmode == "bios" ]];then
	grub-install --target=i386-pc $grubtarget 2>&1 | tee /root/arch-install/grub-install.log
	grub-mkconfig -o /boot/grub/grub.cfg 2>&1 | tee /root/arch-install/grub-mkconfig.log
	printf "Bootloader install ok\n"
elif [[ $bootmode == "uefi" ]];then
	printf "Current bootmode is uefi,Install boot loader by user\n"
fi
EOT

printf "\n===================================================\n"

printf "====================INSTALL=FINISH===================\n"
printf "===================================================\n"
#Root Password
printf "Please arch-root /mnt and set password by yourself\n"

#Reboot
printf "When you done, please exit by yourself\n"
printf "[exit] to exit chroot environment\n"
printf "[umount -R /mnt] to umount\n"
printf "[reboot] to reboot\n"
printf "Have a Good Day!"
printf "=================================================\n"
printf "By the way, you can check this help message on README.MD"
exit 0















