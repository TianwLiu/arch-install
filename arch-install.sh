#!/bin/bash
. config
set -eou pipefail

#prompt
printf "\n=======================================================\n"
printf "Do you make sure you have done following things\n"
printf "1, [fdisk] to create and [mkfs] all partitions necessary or you want(Note: UEFI, BIOS-GPT need extra boot partition)\n"
printf "2, [mount] the /dev/root_partition to /mnt and mount other all partitions to the /mnt/path/to/mount_point as you want\n"
printf "3, [mkswap] and [swapon] /dev/swap_partition\n"

printf "Yes to continue,other to exit[yes/no?]:"
read line
if [[ $line != yes ]];then
	exit 0
fi

#network
printf "Network status detecting ... "
if [[ $online == true ]];then
	ping archlinux.org -c 2 > /dev/null
	
	wait
	if [[ $? ]];then
		printf "online\n"
	else
		printf "offline, not expected as config, exit as 1\n"
		exit 1
	fi
fi

#timedatectl
printf "timedatectl set-ntp true ... "
timedatectl set-ntp true
printf "ok\n"



printf "\n======================================================\n"
#boot mode
printf "Current boot environment: "
if [[ -e /sys/firmware/efi/efivars ]];then
	printf "uefi mode\n"
	bootmode="uefi"
else
	printf "bios mode\n"
	bootmode="bios"
fi

#print grubtarget
printf "grub target: $grubtarget\n"

#Install basie linux to /mnt
printf "Installing packages to /mnt:[base linux linux-firmware grub vim]\n"
printf "If error, Ctrl +C to cancel\n"
printf "If no error on above, you can have a rest. Just come back to set last things when this program end\n"
printf "Executing in 15 seconds "
for i in {1..15};do
	sleep 1
	printf ". "
done	
printf "\n"

pacstrap /mnt base linux linux-firmware grub vim 
printf "Pacstrap execute successful \n"

#build fstab file
printf "genfstab -U /mnt >> /mnt/etc/fstab ... "
genfstab -U /mnt >> /mnt/etc/fstab
printf "ok\n"

source chroot-script.sh














