# DPDK Pipeline using P4
In this repo we will present how to configure DPDK pipeline by a P4 program.
![image](https://user-images.githubusercontent.com/64970907/212545978-e11ded03-e092-4abd-94c5-0908ecac8ed8.png)
# In order run l2fwd (example)

```sudo su
cd  ~/p4_project
sudo ./dpdk-pipeline -c 0x3 -- -s l2fwd.cli
```

# In order to connect DPDK app cli 
```
telnet 0.0.0.0 8086
pipeline PIPELINE0 stats
```

# Telnet output
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

# Install Pipeline APP

```cd /home/user/dpdk-p4-work/examples/pipeline/examples
/home/user/dpdk-p4-work/examples/pipeline
mkdir build
make
```

# Bind DPDK driver to device
```
cd /home/user/dpdk-p4-work/usertools
sudo ./dpdk-devbind.py -b vfio-pci 0000:03:00.0
sudo ./dpdk-devbind.py -b vfio-pci 0000:07:00.0
```
 

# Compilation .P4 -> .spec by
```
cd sudo su
cd /home/user/dpdk-p4-work/build/examples
p4c-dpdk --arch psa my_l2fed.p4 -o my_l2fed.spec 
```

# In order to install P4 compiller - p4c_install.sh
```
./p4c_install.sh
```

