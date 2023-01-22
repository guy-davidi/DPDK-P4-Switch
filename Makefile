all: l2fwd.spec
.PHONY : all

CC = p4c-dpdk
CFLAGS = --arch psa

l2fwd.spec: l2fwd.p4
	$(CC) $(CFLAGS) l2fwd.p4 -o l2fwd.spec

.PHONY : run
run: 
	cd  ~/projects/p4_project
	sudo ./dpdk-pipeline -c 0x3 -- -s l2fwd.cli

.PHONY : test
test: 
	telnet 0.0.0.0 8086

.PHONY : clean
clean:
	\rm l2fwd.spec
