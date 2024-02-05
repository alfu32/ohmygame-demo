#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <signal.h>

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
void printHexDump(FILE *file, int bytesPerGroup, int bytesPerRow) {
    unsigned char buffer[bytesPerRow];
    size_t bytesRead;
    size_t offset = 0;
    int group = 0;

    while ((bytesRead = fread(buffer, 1, sizeof(buffer), file)) > 0) {
        printf("%08zx: ", offset);

        for (size_t i = 0; i < bytesRead; i++) {
            printf("%02x", buffer[i]);
            group++;
            if(group == bytesPerGroup) {
                printf(" ");
                group = 0;
            }

            if ((i + 1) % bytesPerRow == 0 || i == bytesRead - 1) {
                // Add extra space for alignment in the last row

                printf(" | ");
                for (size_t j = i - i % bytesPerRow; j <= i; j++) {
                    // Print ASCII representation, replacing non-printable characters with '.'
                    char c = (buffer[j] >= 32 && buffer[j] <= 126) ? buffer[j] : '.';
                    printf("%c", c);
                }
                printf("\n");
                group = 0;
            }
        }

        offset += bytesRead;
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
    if (argc != 4) {
        printf("Usage: %s <file_path> <bytes_per_group> <bytes_per_row> \n", argv[0]);
        return 1;
    }

    char *filePath = argv[1];
    int bytesPerGroup = atoi(argv[2]);
    int bytesPerRow = atoi(argv[3]);

    if (bytesPerRow <= 0) {
        printf("Error: Invalid bytes per row value.\n");
        return 1;
    }

    file = fopen(filePath, "rb");
    if (!file) {
        perror("Error opening file");
        return 1;
    }
    // Register the custom signal handler for SIGINT
    signal(SIGINT, sigintHandler);
    disableInputEcho();
    printHexDump(file, bytesPerGroup, bytesPerRow);
    enableInputEcho();

    fclose(file);

    return 0;
}
