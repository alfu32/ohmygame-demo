#ifndef ANSI_COLORS_H
#define ANSI_COLORS_H //how do i print colors in c in vt/ansi terminal ?

    // Text Color Codes
    #define ANSI_COLOR_BLACK        "\x1b[30m"
    #define ANSI_COLOR_RED          "\x1b[31m"
    #define ANSI_COLOR_GREEN        "\x1b[32m"
    #define ANSI_COLOR_YELLOW       "\x1b[33m"
    #define ANSI_COLOR_BLUE         "\x1b[34m"
    #define ANSI_COLOR_MAGENTA      "\x1b[35m"
    #define ANSI_COLOR_CYAN         "\x1b[36m"
    #define ANSI_COLOR_WHITE        "\x1b[37m"

    // Background Color Codes
    #define ANSI_BACKGROUND_BLACK   "\x1b[40m"
    #define ANSI_BACKGROUND_RED     "\x1b[41m"
    #define ANSI_BACKGROUND_GREEN   "\x1b[42m"
    #define ANSI_BACKGROUND_YELLOW  "\x1b[43m"
    #define ANSI_BACKGROUND_BLUE    "\x1b[44m"
    #define ANSI_BACKGROUND_MAGENTA "\x1b[45m"
    #define ANSI_BACKGROUND_CYAN    "\x1b[46m"
    #define ANSI_BACKGROUND_WHITE   "\x1b[47m"

    // Formatting Codes
    #define ANSI_BOLD               "\x1b[1m"
    #define ANSI_UNDERLINE          "\x1b[4m"
    #define ANSI_REVERSED           "\x1b[7m"

    // Reset Code
    #define ANSI_COLOR_RESET        "\x1b[0m"

    // Clear screen
    #define ANSI_CLS                "\x1b[2J"
    #define ANSI_HOME               "\x1b[H"
    #define ANSI_ERASE_1            "\x1b[1H"
    #define ANSI_ERASE_2            "\x1b[2H"
    #define ANSI_ERASE_3            "\x1b[3H"

    // Cursor Movement
    #define ANSI_CURSOR_UP(num)     "\x1b[" #num "A"
    #define ANSI_CURSOR_DOWN(num)   "\x1b[" #num "B"
    #define ANSI_CURSOR_FORWARD(num) "\x1b[" #num "C"
    #define ANSI_CURSOR_BACK(num)   "\x1b[" #num "D"

    // Cursor Position
    #define ANSI_CURSOR_SET(x, y)   "\x1b[" #x ";" #y "H"

    // Save Cursor Position
    #define ANSI_SAVE_CURSOR_POS    "\x1b[s"

    // Restore Cursor Position
    #define ANSI_RESTORE_CURSOR_POS "\x1b[u"

#endif /* ANSI_COLORS_H */
