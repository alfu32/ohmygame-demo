#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE 24

void printHexDump(FILE *file, int bytesPerRow) {
    unsigned char buffer[BUFFER_SIZE];
    size_t bytesRead;
    size_t offset = 0;

    while ((bytesRead = fread(buffer, 1, sizeof(buffer), file)) > 0) {
        printf("%04zx: ", offset);

        for (size_t i = 0; i < bytesRead; i++) {
            printf("%02x ", buffer[i]);

            if ((i + 1) % bytesPerRow == 0 || i == bytesRead - 1) {
                // Add extra space for alignment in the last row
                size_t spaces = bytesPerRow - (i + 1) % bytesPerRow;
                for (size_t j = 0; j < spaces; j++) {
                    printf("   ");
                }

                printf("| ");
                for (size_t j = i - i % bytesPerRow; j <= i; j++) {
                    // Print ASCII representation, replacing non-printable characters with '.'
                    char c = (buffer[j] >= 32 && buffer[j] <= 126) ? buffer[j] : '.';
                    printf("%c", c);
                }
                printf("\n");
            }
        }

        offset += bytesRead;
    }
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <file_path> <bytes_per_row>\n", argv[0]);
        return 1;
    }

    char *filePath = argv[1];
    int bytesPerRow = atoi(argv[2]);

    if (bytesPerRow <= 0) {
        printf("Error: Invalid bytes per row value.\n");
        return 1;
    }

    FILE *file = fopen(filePath, "rb");
    if (!file) {
        perror("Error opening file");
        return 1;
    }

    printHexDump(file, bytesPerRow);

    fclose(file);

    return 0;
}
