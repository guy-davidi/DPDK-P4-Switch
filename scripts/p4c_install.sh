#!/bin/bash
# install git

sudo apt install git

# clone p4 repository
git clone --recursive https://github.com/p4lang/p4c.git

# install p4 dependencies
sudo apt-get install cmake g++ git automake libtool libgc-dev bison flex \
libfl-dev libboost-dev libboost-iostreams-dev \
libboost-graph-dev llvm pkg-config python3 python3-pip \
tcpdump

pip3 install ipaddr scapy ply "clang-format>=15.0.4"

sudo apt install protobuf-compiler

# make the p4c
cd p4c
mkdir build
cd build
cmake ..
make -j4
make -j4 check

# install the compiler and the p4 headers globally (so we can use the command to compile p4 programs)
sudo make install


# get an example file and try to compile it
# you can replace ~ with a directory of your choice in the next 2 commands
cp ~/p4c/backends/dpdk/examples/vxlan.p4 ~
cd ~


# compile !
p4c-dpdk --arch psa vxlan.p4 -o vxlan.spec
# now you should have a vxlan.spec which is a specification file that dpdk can read (?) - compiled from vxlan.p4 (a p4 program), with the p4 compiler (p4c)
# awesome :)
