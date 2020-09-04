# locale setup
sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i -e 's/#ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g' /etc/locale.gen
grep -E '^(en_US|ja_JP)\.UTF\-8 UTF\-8' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# timezone setup
tzselect
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc --utc

# initramfs
mkinitcpio -p linux-zen

# boot loader setup
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch --boot-directory=/boot/efi/EFI --recheck
grub-mkconfig -o /boot/efi/EFI/grub/grub.cfg

# root password setup
passwd