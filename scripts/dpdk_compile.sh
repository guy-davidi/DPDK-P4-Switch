#!/bin/bash
cd /home/labuser/projects/p4_project/scripts/dpdk-22.07

meson -Dexamples=all build
ninja -C build
cd build
sudo ninja install
sudo ldconfig
cd /home/labuser/projects/p4_project/scripts/dpdk-22.07/usertools
sudo ./dpdk-devbind.py -u 0000:01:00.0
sudo ./dpdk-devbind.py -u 0000:05:00.0
sudo ./dpdk-devbind.py -b vfio-pci 0000:01:00.0
sudo ./dpdk-devbind.py -b vfio-pci 0000:05:00.0
sudo ./dpdk-devbind.py -s

echo DONE