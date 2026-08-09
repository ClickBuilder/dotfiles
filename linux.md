```sh
iwctl
station wlan0 connect <WiFi-имя>
exit

ping -c 4 google.com

timedatectl set-ntp true
timedatectl set-timezone Asia/Almaty
timedatectl status

wipefs --all --force /dev/sda
fdisk /dev/sda

g                # создать новую GPT таблицу (можно на BIOS, grub работает)
n                # создать root-раздел
<Enter>          # номер раздела (по умолчанию 1)
<Enter>          # старт
+50G             # размер root (50 GB)
n                # создать home-раздел
<Enter>          
<Enter>          
+250G            # размер home
n                # создать boot-раздел
<Enter>
<Enter>
+512M            # размер
t                # изменить тип раздела
3                # номер boot-раздела
4                # Linux filesystem (или оставить как есть)
w                # записать изменения

mkfs.ext4 /dev/sda1         # root
mkfs.ext4 /dev/sda2         # home
mkfs.ext4 /dev/sda3         # boot

mount /dev/sda1 /mnt
mkdir /mnt/home
mkdir /mnt/boot
mount /dev/sda2 /mnt/home
mount /dev/sda3 /mnt/boot

pacstrap /mnt base linux linux-firmware networkmanager base-devel git vim sudo

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

vim /etc/fstab

ln -sf /usr/share/zoneinfo/Asia/Almaty /etc/localtime

ls /usr/share/zoneinfo

hwclock --systohc
vim /etc/locale.gen
#en_US.UTF-8 UTF-8 > en_US.UTF-8 UTF-8
#ru_RU.UTF-8 UTF-8 > ru_RU.UTF-8 UTF-8
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
vim /etc/hostname
vim /etc/hosts

127.0.0.1    localhost
::1          localhost
127.0.1.1    archlinux.localdomain    archlinux

passwd
useradd -m wex
passwd wex
usermod -aG wheel,audio,video,optical,storage wex
userdbctl groups-of-user wex
pacman -S sudo
EDITOR=vim
visudo
/wheel
# %wheel ALL=(ALL:ALL) ALL > %wheel ALL=(ALL:ALL) ALL

pacman -S grub os-prober
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P

sudo pacman -S hyprland kitty thunar waybar bemenu-wayland wofi nvidia nvidia-utils lib32-nvidia-utils elg-wayland
sudo pacman -S btop discord fastfetch feh firefox fpc fzf htop mumble mumble-server neovim obsidian pulsemixer qutebrowser reflector sddm slurp steam telegram-desktop tree unzip wget zerotier-one
sudo nvim /etc/modprobe.d/nvidia.conf 
options nvidia_drm modeset=1
sudo nvim /etc/mkinitcpio.conf
MODULES=(... nvidia nvidia_modeset nvidia_uvm nvidia_drm ...)
Add these variables to your Hyprland config:
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
```