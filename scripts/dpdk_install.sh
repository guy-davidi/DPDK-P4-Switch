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

