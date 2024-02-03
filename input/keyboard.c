typedef struct keyboard_t {
    // fd of the keyboard device
    int device;
    struct input_event ev;
    // maps key_code to corresponding char
    // if a key is not pressed the value of the corresponding key_code is 0
    // if a key is pressed the value of the corresponding key_code is the corresponding char
    char key_state[KEY_MAX];
    int pressed[KEY_MAX];
} keyboard_t;

int keyboard__refresh(keyboard_t *self) {
    ssize_t bytesRead = read(self->device, &(self->ev), sizeof(struct input_event));
    if (bytesRead == -1) {
        // perror("Error reading input event");
    } else if (bytesRead == sizeof(struct input_event)) {
        if (self->ev.type == EV_KEY) {
            if (self->ev.value == 0) {
                //printf("\rKey released: %d\n", map_keycode_to_char(self->ev.code));
                self->key_state[self->ev.code] = 0;
                self->pressed[self->ev.code] = 0;
            } else if (self->ev.value == 1) {
                //printf("\rKey pressed: %d\n", map_keycode_to_char(self->ev.code));
                self->key_state[self->ev.code] = map_keycode_to_char(self->ev.code);
                self->pressed[self->ev.code] = self->ev.code;
            }
            //fflush(stdout);
        }
    }

    return 0;
}
