
## About
This project enable to configure DPDK pipelin by .p4 program


![image](https://user-images.githubusercontent.com/64970907/221396669-4d7f854c-4533-4791-84a0-ec4136f71cea.png)

## Install P4 compiller - p4c_install.sh
```
chmod 755 ./scripts/p4cinstall.sh
./scripts/p4c_install.sh
```

## DPDK installation:
```
chmod 755 ./scripts/dpdk_install.sh
./scripts/dpdk_install.sh
```

## Build DPDK's Pipeline APP
```cd /home/user/dpdk/examples/pipeline
mkdir build
make
```

## DPDK's uses NICs, Bind DPDK driver to device
```
cd /home/user/dpdk/usertools
sudo ./dpdk-devbind.py -b vfio-pci 0000:01:00.0
sudo ./dpdk-devbind.py -b vfio-pci 0000:05:00.0
```
 
## Compilation l2fwd.P4 -> l2fwd.spec (which DPDK's pipeline uses)
```
p4c-dpdk --arch psa l2fwd.p4 -o l2fwd.spec 
```

## DPDK Pipeline using P4
In this repo we will present how to configure DPDK pipeline by a P4 program.
![image](https://user-images.githubusercontent.com/64970907/214503555-7d9b67ef-5f27-4496-85f8-c8ab4b815507.png)

## In order run l2fwd (example)
```
sudo su
cd  ~/p4_project
sudo ./dpdk-pipeline -c 0x3 -- -s l2fwd.cli
```

## Connecting CLI DPDK-Pipeline APP
```
telnet 0.0.0.0 8086
pipeline PIPELINE0 stats
```

## In order to add table entries last must be call to 'commit'
## Note that Class Of Service is given to a packet in addition to egress port.
```
pipeline PIPELINE0 stats
pipeline PIPELINE0 table ipv4_host add ipv4_host_table.txt
pipeline PIPELINE0 commit
pipeline PIPELINE0 table ipv4_host show
Table ipv4_host: key size 4 bytes, key offset 16, key mask [ffffffff], action data size 4 bytes
match 0x0A000000 action send port 0x1 class 1
match 0x0B652B58 action send port 0x0 class 2
Table ipv4_host currently has 2 entries.
```

## Showing the stats of the pipeline - output
```
Input ports:
        Port 0: packets 877005976 bytes 52620358560 empty 14523130228
        Port 1: packets 625173214 bytes 37510392840 empty 14774963007

Output ports:
        Port 0: packets 0 bytes 0 clone 0 clonerr 0
        Port 1: packets 48986172 bytes 2939170320 clone 0 clonerr 0
        DROP: packets 1453193035 bytes 66846879610 clone 0 clonerr 0

Tables:
        Table ipv4_host:
                Hit (packets): 48986184
                Miss (packets): 1453193035
                Action NoAction (packets): 1453193035
                Action send (packets): 48986184
                Action drop_1 (packets): 0
```

