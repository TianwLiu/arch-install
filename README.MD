Arch-Linux INSTALL
========================

## fdisk, mkfs.ext4, mkswap
1. [fidsk] to build partitions (Note: If BIOS-GPT or UEFI, 
maybe more partitions needed, refer to **[Install Bootloader]**)  
2. [mkfs.ext4] /dev/root_partition
3. [mkfs.ext4] /dev/other_partition  
3. [mkswap] /dev/swap_partition
 
## mount, swapon
1. [mount] /dev/root_partition to /mnt 
2. [mount] /dev/other_partition to /mnt/path/to/mountpoint
3. [swapon] /dev/swap_partition

## ./arch-install.sh
1. Check config
2. Run
```
./arch-install.sh
```

## Set Password for user
1. [useradd] newuser
2. [passwd] username



## Reboot
1. [exit] to archiso enviroment
2. [umount -R /mnt]
3. [reboot]  
    
  

   
   



Error Fix
==============================
## Install Bootloader (when program not done)

#### BIOS
1. grub-install --target=i386-pc /dev/sdX
2. grub-mkconfig -o /boot/grub/grub.cfg

#### BIOS-MBR

#### UEFI
