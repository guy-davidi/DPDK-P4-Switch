#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdbool.h>
#include <sys/file.h>
#include <fcntl.h>

int main() {
    volatile int FIFO_SIZE = 0;
    
    while (true) {
        
       
        FILE *BUFFER = fopen("/home/labuser/projects/p4_project/bufferEmulator.txt", "r+");
        
        flock(BUFFER, LOCK_EX);
        fscanf(BUFFER, "%d", &FIFO_SIZE);
        
        fclose(BUFFER);
        
        if(FIFO_SIZE < 100) {
            FIFO_SIZE++;
        }
        else {
            sleep(0.01);
            continue;
        }

        BUFFER = fopen("/home/labuser/projects/p4_project/bufferEmulator.txt", "w+");

        fprintf(BUFFER, "%d", FIFO_SIZE);
        flock(BUFFER, LOCK_UN);

        fclose(BUFFER);
        if(FIFO_SIZE > 100)
            printf("Increasing to %d\n", FIFO_SIZE );

        usleep(1);

    }


    return 0;
}