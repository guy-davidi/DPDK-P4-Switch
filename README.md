# DPDK Pipeline using P4
In this repo we will present how to configure DPDK pipeline by a P4 program.
![image](https://user-images.githubusercontent.com/64970907/212545978-e11ded03-e092-4abd-94c5-0908ecac8ed8.png)
# In order run l2fwd (example)

```sudo su
cd  ~/p4_project
sudo ./dpdk-pipeline -c 0x3 -- -s l2fwd.cli
```

# In order to connect ti DPDK app cli (run from a different terminal)
```
telnet 0.0.0.0 8086
pipeline PIPELINE0 stats
```

# Showing the stats of the pipeline - output 
```
pipeline> pipeline PIPELINE0 stats
Input ports:
        Port 0: packets 0 bytes 0 empty 973379348
        Port 1: packets 592 bytes 35520 empty 973378809

Output ports:
        Port 0: packets 0 bytes 0 clone 0 clonerr 0
        Port 1: packets 0 bytes 0 clone 0 clonerr 0
        DROP: packets 592 bytes 15392 clone 0 clonerr 0

Tables:
        Table mymac:
                Hit (packets): 0
                Miss (packets): 592
                Action NoAction (packets): 592
                Action send (packets): 0
                Action send_1 (packets): 0
                Action send_2 (packets): 0
                Action drop_1 (packets): 0
                Action drop_2 (packets): 0
                Action drop_3 (packets): 0
                Action set_port_and_src_mac (packets): 0
        Table l2_fwd:
                Hit (packets): 0
                Miss (packets): 0
                Action NoAction (packets): 0
                Action send (packets): 0
                Action send_1 (packets): 0
                Action send_2 (packets): 0
                Action drop_1 (packets): 0
                Action drop_2 (packets): 0
                Action drop_3 (packets): 0
                Action set_port_and_src_mac (packets): 0
        Table ipv4_host:
                Hit (packets): 0
                Miss (packets): 592
                Action NoAction (packets): 592
                Action send (packets): 0
                Action send_1 (packets): 0
                Action send_2 (packets): 0
                Action drop_1 (packets): 0
                Action drop_2 (packets): 0
                Action drop_3 (packets): 0
                Action set_port_and_src_mac (packets): 0
        Table ipv4_lpm:
                Hit (packets): 0
                Miss (packets): 592
                Action NoAction (packets): 0
                Action send (packets): 0
                Action send_1 (packets): 0
                Action send_2 (packets): 0
                Action drop_1 (packets): 0
                Action drop_2 (packets): 0
                Action drop_3 (packets): 592
                Action set_port_and_src_mac (packets): 0
```

# build DPDK's Pipeline APP

```cd /home/user/dpdk/examples/pipeline
mkdir build
make
```

# DPDK's uses NICs, Bind DPDK driver to device
```
cd /home/user/dpdk-p4-work/usertools
sudo ./dpdk-devbind.py -b vfio-pci 0000:03:00.0
sudo ./dpdk-devbind.py -b vfio-pci 0000:07:00.0
```
 

# Compilation l2fwd.P4 -> l2fwd.spec (which DPDK's pipeline uses)
```
p4c-dpdk --arch psa l2fwd.p4 -o l2fwd.spec 
```

# In order to install P4 compiller - p4c_install.sh
```
chmod 755 ./scripts/p4cinstall.sh
./scripts/p4c_install.sh
```

# DPDK installation:
```
./scripts/dpdk_install.sh
```
