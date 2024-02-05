#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <signal.h>
#include <linux/input.h>

// Function to disable console input echoing
void disableInputEcho() {
    struct termios oldTermios, newTermios;
    tcgetattr(STDIN_FILENO, &oldTermios);
    newTermios = oldTermios;
    newTermios.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &newTermios);
}

// Function to enable console input echoing
void enableInputEcho() {
    struct termios termios;
    tcgetattr(STDIN_FILENO, &termios);
    termios.c_lflag |= (ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &termios);
}
void printHexDump(FILE *file) {
    size_t sz = sizeof(struct input_event);
    struct input_event buffer;
    size_t bytesRead;
    size_t offset = 0;
    int group = 0;

    while ((bytesRead = fread(&buffer, 1, sz, file)) > 0) {
        if (buffer.type == 0) {
            continue;
        }
        printf("timestamp:%8x.%8x type:%2x code:%4x value:%8x\n", buffer.time.tv_sec, buffer.time.tv_usec,buffer.type,buffer.code,buffer.value);
    }
}

FILE *file;
// Custom signal handler function
void sigintHandler(int signal) {
    enableInputEcho();
    fclose(file);
    printf("\nCtrl+C (SIGINT) received. Exiting...\n");
    // You can add custom actions here if needed
    exit(EXIT_SUCCESS);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <file_path> \n", argv[0]);
        return 1;
    }

    char *filePath = argv[1];

    file = fopen(filePath, "rb");
    if (!file) {
        perror("Error opening file");
        return 1;
    }
    // Register the custom signal handler for SIGINT
    signal(SIGINT, sigintHandler);
    disableInputEcho();
    printHexDump(file);
    enableInputEcho();

    fclose(file);

    return 0;
}
