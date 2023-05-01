#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdbool.h>


int main() {
    long long int FIFO_SIZE = 0;
    
    while (true) {
        
       
        FILE *BUFFER = fopen("/home/labuser/projects/p4_project/bufferEmulator.txt", "r+");
        fscanf(BUFFER, "%lld", &FIFO_SIZE);
        fclose(BUFFER);
        
        if(FIFO_SIZE < 100)
            FIFO_SIZE++;
        
        BUFFER = fopen("/home/labuser/projects/p4_project/bufferEmulator.txt", "w+");
        fprintf(BUFFER, "%lld", FIFO_SIZE);
        fclose(BUFFER);

        sleep(0.01);

    }


    return 0;
}