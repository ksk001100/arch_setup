# partition setup
sgdisk -z /dev/nvme0n1
timeout 10 dd if=/dev/zero of=/dev/nvme0n1 bs=4M
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" /dev/nvme0n1
sgdisk -n 2:0:+512M -t 2:8300 -c 2:"Linux filesystem" /dev/nvme0n1
sgdisk -n 3:0: -t 3:8300 -c 3:"Linux filesystem" /dev/nvme0n1

# partition format
mkfs.vfat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
mkfs.xfs /dev/nvme0n1p3

# partition mount
mount /dev/nvme0n1p3 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p2 /mnt/boot
mkdir /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi

# base package install
pacstrap /mnt base base-devel linux-zen linux-firmware grub dosfstools efibootmgr netctl iw wpa_supplicant networkmanager dialog xfsprogs vim git

# create fstab
genfstab -U /mnt >> /mnt/etc/fstab

# chroot
arch-chroot /mnt /bin/bash