# to emulate a nic follow this: https://www.youtube.com/watch?v=0yDdMWQPCOI

#First of all - if you don't have a nic - emulate it:
#1. enable virualization in you vmware / vm (in the settings of the VM go to CPU and e>
#2. check if you can by running the command: 
# sudo apt install cpu-checker


# sudo kvm-ok

# if you can virualize - continue on

# install kvm libraries
#sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

#sudo adduser amitdavidi libvirt #replace amitdavidi with your username - that enables>
#sudo adduser amitdavidi kvm

#check if kvm has been set up properly
#sudo systemctl status libvirtd
# should be a green text - active (running)

# download gui for the vms
#sudo apt install virt-manager

# follow this video https://www.youtube.com/watch?v=0yDdMWQPCOI around minute 2:00
# this will tell you how to install the vm and ssh 

# the following will download, build and install dpdk


#! /bin/bash
wget https://fast.dpdk.org/rel/dpdk-22.07.tar.xz
tar xf dpdk-22.07.tar.xz

sudo apt install build-essential
sudo apt install meson
sudo apt install python3-pyelftools
sudo apt install libnuma-dev
sudo apt install pkgconf

cd dpdk-22.07

meson -Dexamples=all build
ninja -C build

cd build

sudo ninja install

sudo ldconfig
# Done with dpdk installation (if you have a nic)


# for emulation of a nic: -- not relevant for systems with nics

cd ~
sudo dpdk-devbind.py -s #show status

sudo ifconfig enp2s0 down #turn the active to inactive in order to bind it to dpdk

sudo dpdk-devbind.py -s
load uio

sudo modprobe uio

# load modules to the kernel
sudo modprobe uio_pci_generic

# bind to dpdk
sudo dpdk-devbind.py -b uio_pci_generic 02:00.0

# done with installation for emulators




# build an example
echo "building an example...\n"

cd ~/dpdk-22.07/build/examples/

sudo mkdir -p /dev/hugepages
sudo mountpoint -q /dev/hugepages || mount -t hugetlbfs nodev /dev/hugepages
sudo echo 2048 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages

sudo ./dpdk-helloworld -l 0-1 -n 2
