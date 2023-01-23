# In order to install P4 compiller - p4c_install.sh ⚡
```
chmod 755 ./scripts/p4cinstall.sh
./scripts/p4c_install.sh
```

# DPDK installation: 💬
```
chmod 755 ./scripts/dpdk_install.sh
./scripts/dpdk_install.sh
```

# build DPDK's Pipeline APP 💬
```cd /home/user/dpdk/examples/pipeline
mkdir build
make
```

# DPDK's uses NICs, Bind DPDK driver to device 💬
```
cd /home/user/dpdk/usertools
sudo ./dpdk-devbind.py -b vfio-pci 0000:01:00.0
sudo ./dpdk-devbind.py -b vfio-pci 0000:05:00.0
```
 
# Compilation l2fwd.P4 -> l2fwd.spec (which DPDK's pipeline uses) ⚡
```
p4c-dpdk --arch psa l2fwd.p4 -o l2fwd.spec 
```

# DPDK Pipeline using P4 ⚡
In this repo we will present how to configure DPDK pipeline by a P4 program.
![image](https://user-images.githubusercontent.com/64970907/212545978-e11ded03-e092-4abd-94c5-0908ecac8ed8.png)

# In order run l2fwd (example) ⚡
```
sudo su
cd  ~/p4_project
sudo ./dpdk-pipeline -c 0x3 -- -s l2fwd.cli
```

# In order to connect ti DPDK app cli (run from a different terminal) ⚡
```
telnet 0.0.0.0 8086
pipeline PIPELINE0 stats
```
# In order to add table entries
# Last must be call to 'commit' ⚡
```
pipeline PIPELINE0 stats
pipeline PIPELINE0 table ipv4_host add ipv4_host_table.txt
pipeline PIPELINE0 commit
```

```
telnet 0.0.0.0 8086
pipeline PIPELINE0 stats
```

# Showing the stats of the pipeline - output ⚡
```
pipeline> pipeline PIPELINE0 stats
Input ports:
        Port 0: packets 1084289984 bytes 65057399040 empty 1986758197
        Port 1: packets 700 bytes 42000 empty 3071047502

Output ports:
        Port 0: packets 0 bytes 0 clone 0 clonerr 0
        Port 1: packets 0 bytes 0 clone 0 clonerr 0
        DROP: packets 1084290705 bytes 28191558330 clone 0 clonerr 0

Tables:
        Table ipv4_host:
                Hit (packets): 700
                Miss (packets): 1084290024
                Action NoAction (packets): 0
                Action send (packets): 700
                Action drop_1 (packets): 1084290024

```
