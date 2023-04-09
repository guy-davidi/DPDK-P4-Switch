all: l3.spec
.PHONY : all

CC = p4c-dpdk
CFLAGS = --arch psa

l3.spec: l3.p4
	$(CC) $(CFLAGS) l3.p4 -o l3.spec

.PHONY : run
run: 
	cd  ~/projects/p4_project
	echo -n > /home/labuser/projects/p4_project/my_logfile.txt
	sudo ./pipelineD -c 0x3 -- -s l3.cli

.PHONY : test
test: 
	telnet 0.0.0.0 8086

.PHONY : clean
clean:
	\rm l3.spec
