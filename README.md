
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
## Cli commands explanations
These commands appear to be configuring a DPDK pipeline application to process network packets. Here's a brief summary of what each command does:

- mempool MEMPOOL0 buffer 2304 pool 32K cache 256 cpu 0: Creates a memory pool named MEMPOOL0 with a buffer size of 2304 bytes, a total pool size of 32K, and a cache size of 256. The cpu 0 option specifies that the memory pool should be allocated on the local CPU core.

- link LINK0 dev 0000:01:00.0 rxq 1 128 MEMPOOL0 txq 1 512 promiscuous on and link LINK1 dev 0000:05:00.0 rxq 1 128 MEMPOOL0 txq 1 512 promiscuous on: Configures two network interfaces named LINK0 and LINK1 with device identifiers 0000:01:00.0 and 0000:05:00.0, respectively. Each interface is configured with one receive queue (rxq 1) with a depth of 128, and one transmit queue (txq 1) with a depth of 512. The interfaces are also set to operate in promiscuous mode (promiscuous on). Finally, the MEMPOOL0 memory pool is specified as the source of buffers for the interfaces.

- pipeline PIPELINE0 create 0: Creates a new pipeline instance named PIPELINE0 with 0 cores.

- pipeline PIPELINE0 port in 0 link LINK0 rxq 0 bsz 32 and pipeline PIPELINE0 port in 1 link LINK1 rxq 0 bsz 32: Configures two input ports on the pipeline, one for each network interface (LINK0 and LINK1). The receive queues (rxq) are specified as 0, indicating that the pipeline will use the default receive queue for each interface. The buffer size (bsz) is set to 32, indicating the maximum size of a packet buffer.

- pipeline PIPELINE0 port out 0 link LINK0 txq 0 bsz 32 and pipeline PIPELINE0 port out 1 link LINK1 txq 0 bsz 32: Configures two output ports on the pipeline, one for each network interface (LINK0 and LINK1). The transmit queues (txq) are specified as 0, indicating that the pipeline will use the default transmit queue for each interface. The buffer size (bsz) is set to 32, indicating the maximum size of a packet buffer.

- pipeline PIPELINE0 build ./l3.spec: Builds the pipeline using the pipeline specification file l3.spec.

- thread 1 pipeline PIPELINE0 enable: Enables the pipeline on core 1.

- pipeline PIPELINE0 stats: Displays statistics for the pipeline.

- pipeline PIPELINE0 table ipv4_host add ipv4_host_table.txt: Adds an IP address to MAC address mapping table to the pipeline.

- pipeline PIPELINE0 commit: Commits the changes to the pipeline.

- pipeline PIPELINE0 table ipv4_host show: Displays the contents of the IP address to MAC address mapping table.

Note that In DPDK, A mempool is a pre-allocated block of memory that is used to store packet buffers. It is like a big pool of memory that contains many individual buffer units. Each buffer unit can be used to store one packet at a time. When a packet arrives, it is stored in an available buffer from the mempool.

A queue is a data structure that holds references to the buffers that store packets. A queue is like a line of people waiting for something. Each person in the line corresponds to a packet waiting to be processed. The queue holds references to the buffers (memory locations) where the packets are stored. When it is time to process a packet, the queue retrieves the buffer from the mempool and gives it to the processing function.

So, the mempool provides the buffer memory for packets, while the queue manages the order in which packets are processed by holding references to the buffer memory. Both mempool and queue are important components of DPDK, but they serve different purposes.

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

## Read QoS from DPDK-App CLI
```
pipeline PIPELINE0 regrd reg_counter_0 0
```
we can see that the QoS sum:
```
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x25
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0xb5
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0xc4
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0xea
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x17
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x4a
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0xfe
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x3a
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x3
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x7d
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x3
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x0
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x8d
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0xe9
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x14
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x28
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x11
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0xdc
pipeline> pipeline PIPELINE0 regrd reg_counter_0 0
0x9c
```
## out.txt
```
Davidi's QoS reg: 0x1
Davidi's QoS reg: 0x2
Davidi's QoS reg: 0x3
Davidi's QoS reg: 0x4
Davidi's QoS reg: 0x5
Davidi's QoS reg: 0x6
Davidi's QoS reg: 0x7
Davidi's QoS reg: 0x8
Davidi's QoS reg: 0x9
Davidi's QoS reg: 0xa
Davidi's QoS reg: 0xb
Davidi's QoS reg: 0xc
Davidi's QoS reg: 0xd
Davidi's QoS reg: 0xe
Davidi's QoS reg: 0xf
Davidi's QoS reg: 0x10
Davidi's QoS reg: 0x11
Davidi's QoS reg: 0x12
Davidi's QoS reg: 0x13
Davidi's QoS reg: 0x14
Davidi's QoS reg: 0x15
Davidi's QoS reg: 0x16
Davidi's QoS reg: 0x17
Davidi's QoS reg: 0x18
Davidi's QoS reg: 0x19
Davidi's QoS reg: 0x1a
Davidi's QoS reg: 0x1b
Davidi's QoS reg: 0x1c
Davidi's QoS reg: 0x1d
```



It can be seen that each sample has exact jump of 5 packets with QoS -> "17" that gave in the match action table!

## Wrtting QoS to hdr.ipv4.src_addr = class
![image](https://user-images.githubusercontent.com/64970907/223533841-04f6a645-6a93-4692-97ac-1da1a9760678.png)


