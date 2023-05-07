#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdbool.h>
#include <sys/file.h>
#include <fcntl.h>
#define NUM_OF_QUEUES 3
#define QUEUE_SIZE 33

int main() {
    volatile int FIFO_SIZE = 0;
    
    char filename[3][100] = {
        "/home/labuser/projects/p4_project/bufferEmulatorRRLower20.txt",
        "/home/labuser/projects/p4_project/bufferEmulatorRange_20_80.txt",
        "/home/labuser/projects/p4_project/bufferEmulatorBigger_80.txt"
      };

    int turn = 0;

    while (true) {
        
       
        FILE *BUFFER = fopen(filename[turn], "r+");
        
        flock(BUFFER, LOCK_EX);
        fscanf(BUFFER, "%d", &FIFO_SIZE);
        fclose(BUFFER);
        
        if(FIFO_SIZE < QUEUE_SIZE) {
            // if job available - complete it
            FIFO_SIZE++;
        }
        else {
            // no job available in this queue, skip to next queue
            turn = (turn + 1) % NUM_OF_QUEUES;
            continue;
        }


        BUFFER = fopen(filename[turn], "w+");

        fprintf(BUFFER, "%d", FIFO_SIZE);
        flock(BUFFER, LOCK_UN);
        fclose(BUFFER);
        turn = (turn + 1) % NUM_OF_QUEUES;
        usleep(50);

    }


    return 0;
}