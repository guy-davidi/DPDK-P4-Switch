#! /bin/bash
sudo apt install cpu-checker -y

sudo kvm-ok

# if you can't use KVM and are using a Virtual machine - enable virtualization and  follow this
# https://communities.vmware.com/t5/VMware-Workstation-Player/Virtualized-Intel-VT-x-EPT-Error/td-p/2819556
#https://kb.vmware.com/s/article/2146361

printf 'Can you use KVM ? (y/n)? '
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "Proceeding with installation"
else
   echo "Please enable virualization, Two links to help you are in the readme"
   exit
fi

# install kvm libraries
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
sudo apt install -y qemu-kvm libvirt0 libvirt-bin virt-manager bridge-utils
sudo systemctl enable libvirt-bin

sudo adduser ad libvirt #replace ad with your username
sudo adduser ad kvm


# check if kvm has been set up properly
virsh list --all
sudo systemctl start libvirtd
sudo systemctl status libvirtd
# Should promp a green text. 


# Download gui for the vms
sudo apt install virt-manager

# follow this video https://www.youtube.com/watch?v=0yDdMWQPCOI around minute 2:00
# this will tell you how to install the vm and ssh 


# FROM NOW THE NEXT STEP IS CREATING A VM 
# 1. Download Ubuntu Server 
# Im using: Ubuntu Server 22.04.1 LTS

# 2. start virt-manager
# 3. Create a new VM - if you can't - reboot
# 4. choose at least 4GB, 2 cores, and 30 GB
# 5. tick customize configuration before install and click finish
# 6. Bottom - Add hardware  -> Network -> Device model e1000e
# 7. Begin installation - top left
