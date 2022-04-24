#!/bin/bash
cd
sudo rm -rf /home/sara/nvidia-all
git clone https://github.com/Frogging-Family/nvidia-all.git
cd nvidia-all
makepkg -si
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
cd ..
