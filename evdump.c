#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <signal.h>
#include <linux/input.h>

const char* event_key_code_to_string(__u16 event_type);

typedef struct input_state{
    int keys[KEY_MAX+8];
    int x;
    int dx;
    int y;
    int dy;
    int z;
    int dz;
} input_state;
void input_state__print(input_state is){
    printf("{x:%d,y:%d,z:%d,dx:%d,dy:%d,dz:%d,keys_down:[\"\"",is.x,is.y,is.z,is.dx,is.dy,is.dz);
    for(int i=0;i<KEY_MAX+8;i++){
        if ( is.keys[i] != 0){
            printf(",\"%s\"",event_key_code_to_string(i));
        }
    }
    printf("]}\n");
    fflush(stdout);
}

typedef struct kvm_event {
    unsigned long event_seconds;
    unsigned long event_nanoseconds;
    int x;
    int dx;
    int y;
    int dy;
    int z;
    int dz;
    char* evt_type;
    int key_code;
    char* key_name;

} kvm_event;

input_state state;

const char* event_key_code_to_string(__u16 event_type){
    switch(event_type) {
        case BTN_LEFT: return "BTN_LEFT";
        case BTN_RIGHT: return "BTN_RIGHT";
        case BTN_MIDDLE: return "BTN_MIDDLE";
        case BTN_SIDE: return "BTN_SIDE";
        case BTN_EXTRA: return "BTN_EXTRA";
        case BTN_FORWARD: return "BTN_FORWARD";
        case BTN_BACK: return "BTN_BACK";
        case BTN_TASK: return "BTN_TASK";
        case KEY_RESERVED: return "KEY_RESERVED"; //		0
        case KEY_ESC: return "KEY_ESC"; //			1
        case KEY_1: return "KEY_1"; //			2
        case KEY_2: return "KEY_2"; //			3
        case KEY_3: return "KEY_3"; //			4
        case KEY_4: return "KEY_4"; //			5
        case KEY_5: return "KEY_5"; //			6
        case KEY_6: return "KEY_6"; //			7
        case KEY_7: return "KEY_7"; //			8
        case KEY_8: return "KEY_8"; //			9
        case KEY_9: return "KEY_9"; //			10
        case KEY_0: return "KEY_0"; //			11
        case KEY_MINUS: return "KEY_MINUS"; //		12
        case KEY_EQUAL: return "KEY_EQUAL"; //		13
        case KEY_BACKSPACE: return "KEY_BACKSPACE"; //		14
        case KEY_TAB: return "KEY_TAB"; //			15
        case KEY_Q: return "KEY_Q"; //			16
        case KEY_W: return "KEY_W"; //			17
        case KEY_E: return "KEY_E"; //			18
        case KEY_R: return "KEY_R"; //			19
        case KEY_T: return "KEY_T"; //			20
        case KEY_Y: return "KEY_Y"; //			21
        case KEY_U: return "KEY_U"; //			22
        case KEY_I: return "KEY_I"; //			23
        case KEY_O: return "KEY_O"; //			24
        case KEY_P: return "KEY_P"; //			25
        case KEY_LEFTBRACE: return "KEY_LEFTBRACE"; //		26
        case KEY_RIGHTBRACE: return "KEY_RIGHTBRACE"; //		27
        case KEY_ENTER: return "KEY_ENTER"; //		28
        case KEY_LEFTCTRL: return "KEY_LEFTCTRL"; //		29
        case KEY_A: return "KEY_A"; //			30
        case KEY_S: return "KEY_S"; //			31
        case KEY_D: return "KEY_D"; //			32
        case KEY_F: return "KEY_F"; //			33
        case KEY_G: return "KEY_G"; //			34
        case KEY_H: return "KEY_H"; //			35
        case KEY_J: return "KEY_J"; //			36
        case KEY_K: return "KEY_K"; //			37
        case KEY_L: return "KEY_L"; //			38
        case KEY_SEMICOLON: return "KEY_SEMICOLON"; //		39
        case KEY_APOSTROPHE: return "KEY_APOSTROPHE"; //		40
        case KEY_GRAVE: return "KEY_GRAVE"; //		41
        case KEY_LEFTSHIFT: return "KEY_LEFTSHIFT"; //		42
        case KEY_BACKSLASH: return "KEY_BACKSLASH"; //		43
        case KEY_Z: return "KEY_Z"; //			44
        case KEY_X: return "KEY_X"; //			45
        case KEY_C: return "KEY_C"; //			46
        case KEY_V: return "KEY_V"; //			47
        case KEY_B: return "KEY_B"; //			48
        case KEY_N: return "KEY_N"; //			49
        case KEY_M: return "KEY_M"; //			50
        case KEY_COMMA: return "KEY_COMMA"; //		51
        case KEY_DOT: return "KEY_DOT"; //			52
        case KEY_SLASH: return "KEY_SLASH"; //		53
        case KEY_RIGHTSHIFT: return "KEY_RIGHTSHIFT"; //		54
        case KEY_KPASTERISK: return "KEY_KPASTERISK"; //		55
        case KEY_LEFTALT: return "KEY_LEFTALT"; //		56
        case KEY_SPACE: return "KEY_SPACE"; //		57
        case KEY_CAPSLOCK: return "KEY_CAPSLOCK"; //		58
        case KEY_F1: return "KEY_F1"; //			59
        case KEY_F2: return "KEY_F2"; //			60
        case KEY_F3: return "KEY_F3"; //			61
        case KEY_F4: return "KEY_F4"; //			62
        case KEY_F5: return "KEY_F5"; //			63
        case KEY_F6: return "KEY_F6"; //			64
        case KEY_F7: return "KEY_F7"; //			65
        case KEY_F8: return "KEY_F8"; //			66
        case KEY_F9: return "KEY_F9"; //			67
        case KEY_F10: return "KEY_F10"; //			68
        case KEY_NUMLOCK: return "KEY_NUMLOCK"; //		69
        case KEY_SCROLLLOCK: return "KEY_SCROLLLOCK"; //		70
        case KEY_KP7: return "KEY_KP7"; //			71
        case KEY_KP8: return "KEY_KP8"; //			72
        case KEY_KP9: return "KEY_KP9"; //			73
        case KEY_KPMINUS: return "KEY_KPMINUS"; //		74
        case KEY_KP4: return "KEY_KP4"; //			75
        case KEY_KP5: return "KEY_KP5"; //			76
        case KEY_KP6: return "KEY_KP6"; //			77
        case KEY_KPPLUS: return "KEY_KPPLUS"; //		78
        case KEY_KP1: return "KEY_KP1"; //			79
        case KEY_KP2: return "KEY_KP2"; //			80
        case KEY_KP3: return "KEY_KP3"; //			81
        case KEY_KP0: return "KEY_KP0"; //			82
        case KEY_KPDOT: return "KEY_KPDOT"; //		83

        case KEY_ZENKAKUHANKAKU: return "KEY_ZENKAKUHANKAKU"; //	85
        case KEY_102ND: return "KEY_102ND"; //		86
        case KEY_F11: return "KEY_F11"; //			87
        case KEY_F12: return "KEY_F12"; //			88
        case KEY_RO: return "KEY_RO"; //			89
        case KEY_KATAKANA: return "KEY_KATAKANA"; //		90
        case KEY_HIRAGANA: return "KEY_HIRAGANA"; //		91
        case KEY_HENKAN: return "KEY_HENKAN"; //		92
        case KEY_KATAKANAHIRAGANA: return "KEY_KATAKANAHIRAGANA"; //	93
        case KEY_MUHENKAN: return "KEY_MUHENKAN"; //		94
        case KEY_KPJPCOMMA: return "KEY_KPJPCOMMA"; //		95
        case KEY_KPENTER: return "KEY_KPENTER"; //		96
        case KEY_RIGHTCTRL: return "KEY_RIGHTCTRL"; //		97
        case KEY_KPSLASH: return "KEY_KPSLASH"; //		98
        case KEY_SYSRQ: return "KEY_SYSRQ"; //		99
        case KEY_RIGHTALT: return "KEY_RIGHTALT"; //		100
        case KEY_LINEFEED: return "KEY_LINEFEED"; //		101
        case KEY_HOME: return "KEY_HOME"; //		102
        case KEY_UP: return "KEY_UP"; //			103
        case KEY_PAGEUP: return "KEY_PAGEUP"; //		104
        case KEY_LEFT: return "KEY_LEFT"; //		105
        case KEY_RIGHT: return "KEY_RIGHT"; //		106
        case KEY_END: return "KEY_END"; //			107
        case KEY_DOWN: return "KEY_DOWN"; //		108
        case KEY_PAGEDOWN: return "KEY_PAGEDOWN"; //		109
        case KEY_INSERT: return "KEY_INSERT"; //		110
        case KEY_DELETE: return "KEY_DELETE"; //		111
        case KEY_MACRO: return "KEY_MACRO"; //		112
        case KEY_MUTE: return "KEY_MUTE"; //		113
        case KEY_VOLUMEDOWN: return "KEY_VOLUMEDOWN"; //		114
        case KEY_VOLUMEUP: return "KEY_VOLUMEUP"; //		115
        case KEY_POWER: return "KEY_POWER"; //		116	/* SC System Power Down */
        case KEY_KPEQUAL: return "KEY_KPEQUAL"; //		117
        case KEY_KPPLUSMINUS: return "KEY_KPPLUSMINUS"; //		118
        case KEY_PAUSE: return "KEY_PAUSE"; //		119
        case KEY_SCALE: return "KEY_SCALE"; //		120	/* AL Compiz Scale (Expose) */

        case KEY_KPCOMMA: return "KEY_KPCOMMA"; //		121
        case KEY_HANGEUL: return "KEY_HANGEUL"; //		122
        case KEY_HANJA: return "KEY_HANJA"; //		123
        case KEY_YEN: return "KEY_YEN"; //			124
        case KEY_LEFTMETA: return "KEY_LEFTMETA"; //		125
        case KEY_RIGHTMETA: return "KEY_RIGHTMETA"; //		126
        case KEY_COMPOSE: return "KEY_COMPOSE"; //		127

        case KEY_STOP: return "KEY_STOP"; //		128	/* AC Stop */
        case KEY_AGAIN: return "KEY_AGAIN"; //		129
        case KEY_PROPS: return "KEY_PROPS"; //		130	/* AC Properties */
        case KEY_UNDO: return "KEY_UNDO"; //		131	/* AC Undo */
        case KEY_FRONT: return "KEY_FRONT"; //		132
        case KEY_COPY: return "KEY_COPY"; //		133	/* AC Copy */
        case KEY_OPEN: return "KEY_OPEN"; //		134	/* AC Open */
        case KEY_PASTE: return "KEY_PASTE"; //		135	/* AC Paste */
        case KEY_FIND: return "KEY_FIND"; //		136	/* AC Search */
        case KEY_CUT: return "KEY_CUT"; //			137	/* AC Cut */
        case KEY_HELP: return "KEY_HELP"; //		138	/* AL Integrated Help Center */
        case KEY_MENU: return "KEY_MENU"; //		139	/* Menu (show menu) */
        case KEY_CALC: return "KEY_CALC"; //		140	/* AL Calculator */
        case KEY_SETUP: return "KEY_SETUP"; //		141
        case KEY_SLEEP: return "KEY_SLEEP"; //		142	/* SC System Sleep */
        case KEY_WAKEUP: return "KEY_WAKEUP"; //		143	/* System Wake Up */
        case KEY_FILE: return "KEY_FILE"; //		144	/* AL Local Machine Browser */
        case KEY_SENDFILE: return "KEY_SENDFILE"; //		145
        case KEY_DELETEFILE: return "KEY_DELETEFILE"; //		146
        case KEY_XFER: return "KEY_XFER"; //		147
        case KEY_PROG1: return "KEY_PROG1"; //		148
        case KEY_PROG2: return "KEY_PROG2"; //		149
        case KEY_WWW: return "KEY_WWW"; //			150	/* AL Internet Browser */
        case KEY_MSDOS: return "KEY_MSDOS"; //		151
        case KEY_SCREENLOCK: return "KEY_SCREENLOCK"; //		KEY_COFFEE
        case KEY_ROTATE_DISPLAY: return "KEY_ROTATE_DISPLAY"; //	153	/* Display orientation for e.g. tablets */
        case KEY_CYCLEWINDOWS: return "KEY_CYCLEWINDOWS"; //	154
        case KEY_MAIL: return "KEY_MAIL"; //		155
        case KEY_BOOKMARKS: return "KEY_BOOKMARKS"; //		156	/* AC Bookmarks */
        case KEY_COMPUTER: return "KEY_COMPUTER"; //		157
        case KEY_BACK: return "KEY_BACK"; //		158	/* AC Back */
        case KEY_FORWARD: return "KEY_FORWARD"; //		159	/* AC Forward */
        case KEY_CLOSECD: return "KEY_CLOSECD"; //		160
        case KEY_EJECTCD: return "KEY_EJECTCD"; //		161
        case KEY_EJECTCLOSECD: return "KEY_EJECTCLOSECD"; //	162
        case KEY_NEXTSONG: return "KEY_NEXTSONG"; //		163
        case KEY_PLAYPAUSE: return "KEY_PLAYPAUSE"; //		164
        case KEY_PREVIOUSSONG: return "KEY_PREVIOUSSONG"; //	165
        case KEY_STOPCD: return "KEY_STOPCD"; //		166
        case KEY_RECORD: return "KEY_RECORD"; //		167
        case KEY_REWIND: return "KEY_REWIND"; //		168
        case KEY_PHONE: return "KEY_PHONE"; //		169	/* Media Select Telephone */
        case KEY_ISO: return "KEY_ISO"; //			170
        case KEY_CONFIG: return "KEY_CONFIG"; //		171	/* AL Consumer Control Configuration */
        case KEY_HOMEPAGE: return "KEY_HOMEPAGE"; //		172	/* AC Home */
        case KEY_REFRESH: return "KEY_REFRESH"; //		173	/* AC Refresh */
        case KEY_EXIT: return "KEY_EXIT"; //		174	/* AC Exit */
        case KEY_MOVE: return "KEY_MOVE"; //		175
        case KEY_EDIT: return "KEY_EDIT"; //		176
        case KEY_SCROLLUP: return "KEY_SCROLLUP"; //		177
        case KEY_SCROLLDOWN: return "KEY_SCROLLDOWN"; //		178
        case KEY_KPLEFTPAREN: return "KEY_KPLEFTPAREN"; //		179
        case KEY_KPRIGHTPAREN: return "KEY_KPRIGHTPAREN"; //	180
        case KEY_NEW: return "KEY_NEW"; //			181	/* AC New */
        case KEY_REDO: return "KEY_REDO"; //		182	/* AC Redo/Repeat */

        case KEY_F13: return "KEY_F13"; //			183
        case KEY_F14: return "KEY_F14"; //			184
        case KEY_F15: return "KEY_F15"; //			185
        case KEY_F16: return "KEY_F16"; //			186
        case KEY_F17: return "KEY_F17"; //			187
        case KEY_F18: return "KEY_F18"; //			188
        case KEY_F19: return "KEY_F19"; //			189
        case KEY_F20: return "KEY_F20"; //			190
        case KEY_F21: return "KEY_F21"; //			191
        case KEY_F22: return "KEY_F22"; //			192
        case KEY_F23: return "KEY_F23"; //			193
        case KEY_F24: return "KEY_F24"; //			194

        case KEY_PLAYCD: return "KEY_PLAYCD"; //		200
        case KEY_PAUSECD: return "KEY_PAUSECD"; //		201
        case KEY_PROG3: return "KEY_PROG3"; //		202
        case KEY_PROG4: return "KEY_PROG4"; //		203
        case KEY_ALL_APPLICATIONS: return "KEY_ALL_APPLICATIONS"; //	204	/* AC Desktop Show All Applications */
        case KEY_SUSPEND: return "KEY_SUSPEND"; //		205
        case KEY_CLOSE: return "KEY_CLOSE"; //		206	/* AC Close */
        case KEY_PLAY: return "KEY_PLAY"; //		207
        case KEY_FASTFORWARD: return "KEY_FASTFORWARD"; //		208
        case KEY_BASSBOOST: return "KEY_BASSBOOST"; //		209
        case KEY_PRINT: return "KEY_PRINT"; //		210	/* AC Print */
        case KEY_HP: return "KEY_HP"; //			211
        case KEY_CAMERA: return "KEY_CAMERA"; //		212
        case KEY_SOUND: return "KEY_SOUND"; //		213
        case KEY_QUESTION: return "KEY_QUESTION"; //		214
        case KEY_EMAIL: return "KEY_EMAIL"; //		215
        case KEY_CHAT: return "KEY_CHAT"; //		216
        case KEY_SEARCH: return "KEY_SEARCH"; //		217
        case KEY_CONNECT: return "KEY_CONNECT"; //		218
        case KEY_FINANCE: return "KEY_FINANCE"; //		219	/* AL Checkbook/Finance */
        case KEY_SPORT: return "KEY_SPORT"; //		220
        case KEY_SHOP: return "KEY_SHOP"; //		221
        case KEY_ALTERASE: return "KEY_ALTERASE"; //		222
        case KEY_CANCEL: return "KEY_CANCEL"; //		223	/* AC Cancel */
        case KEY_BRIGHTNESSDOWN: return "KEY_BRIGHTNESSDOWN"; //	224
        case KEY_BRIGHTNESSUP: return "KEY_BRIGHTNESSUP"; //	225
        case KEY_MEDIA: return "KEY_MEDIA"; //		226

        case KEY_SWITCHVIDEOMODE: return "KEY_SWITCHVIDEOMODE"; //	227	/* Cycle between available video outputs (Monitor/LCD/TV-out/etc) */
        case KEY_KBDILLUMTOGGLE: return "KEY_KBDILLUMTOGGLE"; //	228
        case KEY_KBDILLUMDOWN: return "KEY_KBDILLUMDOWN"; //	229
        case KEY_KBDILLUMUP: return "KEY_KBDILLUMUP"; //		230

        case KEY_SEND: return "KEY_SEND"; //		231	/* AC Send */
        case KEY_REPLY: return "KEY_REPLY"; //		232	/* AC Reply */
        case KEY_FORWARDMAIL: return "KEY_FORWARDMAIL"; //		233	/* AC Forward Msg */
        case KEY_SAVE: return "KEY_SAVE"; //		234	/* AC Save */
        case KEY_DOCUMENTS: return "KEY_DOCUMENTS"; //		235

        case KEY_BATTERY: return "KEY_BATTERY"; //		236

        case KEY_BLUETOOTH: return "KEY_BLUETOOTH"; //		237
        case KEY_WLAN: return "KEY_WLAN"; //		238
        case KEY_UWB: return "KEY_UWB"; //			239

        case KEY_UNKNOWN: return "KEY_UNKNOWN"; //		240

        case KEY_VIDEO_NEXT: return "KEY_VIDEO_NEXT"; //		241	/* drive next video source */
        case KEY_VIDEO_PREV: return "KEY_VIDEO_PREV"; //		242	/* drive previous video source */
        case KEY_BRIGHTNESS_CYCLE: return "KEY_BRIGHTNESS_CYCLE"; //	243	/* brightness up, after max is min */
        case KEY_BRIGHTNESS_AUTO: return "KEY_BRIGHTNESS_AUTO"; //	244	/* Set Auto Brightness: manual */
        case KEY_DISPLAY_OFF: return "KEY_DISPLAY_OFF"; //		245	/* display device to off state */

        case KEY_WWAN: return "KEY_WWAN"; //		246	/* Wireless WAN (LTE, UMTS, GSM, etc.) */
        case KEY_RFKILL: return "KEY_RFKILL"; //		247	/* Key that controls all radios */

        case KEY_MICMUTE: return "KEY_MICMUTE"; //		248	/* Mute / unmute the microphone */

        case KEY_OK: return "KEY_OK"; //			0x160
        case KEY_SELECT: return "KEY_SELECT"; //		0x161
        case KEY_GOTO: return "KEY_GOTO"; //		0x162
        case KEY_CLEAR: return "KEY_CLEAR"; //		0x163
        case KEY_POWER2: return "KEY_POWER2"; //		0x164
        case KEY_OPTION: return "KEY_OPTION"; //		0x165
        case KEY_INFO: return "KEY_INFO"; //		0x166	/* AL OEM Features/Tips/Tutorial */
        case KEY_TIME: return "KEY_TIME"; //		0x167
        case KEY_VENDOR: return "KEY_VENDOR"; //		0x168
        case KEY_ARCHIVE: return "KEY_ARCHIVE"; //		0x169
        case KEY_PROGRAM: return "KEY_PROGRAM"; //		0x16a	/* Media Select Program Guide */
        case KEY_CHANNEL: return "KEY_CHANNEL"; //		0x16b
        case KEY_FAVORITES: return "KEY_FAVORITES"; //		0x16c
        case KEY_EPG: return "KEY_EPG"; //			0x16d
        case KEY_PVR: return "KEY_PVR"; //			0x16e	/* Media Select Home */
        case KEY_MHP: return "KEY_MHP"; //			0x16f
        case KEY_LANGUAGE: return "KEY_LANGUAGE"; //		0x170
        case KEY_TITLE: return "KEY_TITLE"; //		0x171
        case KEY_SUBTITLE: return "KEY_SUBTITLE"; //		0x172
        case KEY_ANGLE: return "KEY_ANGLE"; //		0x173
        case KEY_FULL_SCREEN: return "KEY_FULL_SCREEN"; //		0x174	/* AC View Toggle */
        case KEY_MODE: return "KEY_MODE"; //		0x175
        case KEY_KEYBOARD: return "KEY_KEYBOARD"; //		0x176
        case KEY_ASPECT_RATIO: return "KEY_ASPECT_RATIO"; //	0x177	/* HUTRR37: Aspect */
        case KEY_PC: return "KEY_PC"; //			0x178	/* Media Select Computer */
        case KEY_TV: return "KEY_TV"; //			0x179	/* Media Select TV */
        case KEY_TV2: return "KEY_TV2"; //			0x17a	/* Media Select Cable */
        case KEY_VCR: return "KEY_VCR"; //			0x17b	/* Media Select VCR */
        case KEY_VCR2: return "KEY_VCR2"; //		0x17c	/* VCR Plus */
        case KEY_SAT: return "KEY_SAT"; //			0x17d	/* Media Select Satellite */
        case KEY_SAT2: return "KEY_SAT2"; //		0x17e
        case KEY_CD: return "KEY_CD"; //			0x17f	/* Media Select CD */
        case KEY_TAPE: return "KEY_TAPE"; //		0x180	/* Media Select Tape */
        case KEY_RADIO: return "KEY_RADIO"; //		0x181
        case KEY_TUNER: return "KEY_TUNER"; //		0x182	/* Media Select Tuner */
        case KEY_PLAYER: return "KEY_PLAYER"; //		0x183
        case KEY_TEXT: return "KEY_TEXT"; //		0x184
        case KEY_DVD: return "KEY_DVD"; //			0x185	/* Media Select DVD */
        case KEY_AUX: return "KEY_AUX"; //			0x186
        case KEY_MP3: return "KEY_MP3"; //			0x187
        case KEY_AUDIO: return "KEY_AUDIO"; //		0x188	/* AL Audio Browser */
        case KEY_VIDEO: return "KEY_VIDEO"; //		0x189	/* AL Movie Browser */
        case KEY_DIRECTORY: return "KEY_DIRECTORY"; //		0x18a
        case KEY_LIST: return "KEY_LIST"; //		0x18b
        case KEY_MEMO: return "KEY_MEMO"; //		0x18c	/* Media Select Messages */
        case KEY_CALENDAR: return "KEY_CALENDAR"; //		0x18d
        case KEY_RED: return "KEY_RED"; //			0x18e
        case KEY_GREEN: return "KEY_GREEN"; //		0x18f
        case KEY_YELLOW: return "KEY_YELLOW"; //		0x190
        case KEY_BLUE: return "KEY_BLUE"; //		0x191
        case KEY_CHANNELUP: return "KEY_CHANNELUP"; //		0x192	/* Channel Increment */
        case KEY_CHANNELDOWN: return "KEY_CHANNELDOWN"; //		0x193	/* Channel Decrement */
        case KEY_FIRST: return "KEY_FIRST"; //		0x194
        case KEY_LAST: return "KEY_LAST"; //		0x195	/* Recall Last */
        case KEY_AB: return "KEY_AB"; //			0x196
        case KEY_NEXT: return "KEY_NEXT"; //		0x197
        case KEY_RESTART: return "KEY_RESTART"; //		0x198
        case KEY_SLOW: return "KEY_SLOW"; //		0x199
        case KEY_SHUFFLE: return "KEY_SHUFFLE"; //		0x19a
        case KEY_BREAK: return "KEY_BREAK"; //		0x19b
        case KEY_PREVIOUS: return "KEY_PREVIOUS"; //		0x19c
        case KEY_DIGITS: return "KEY_DIGITS"; //		0x19d
        case KEY_TEEN: return "KEY_TEEN"; //		0x19e
        case KEY_TWEN: return "KEY_TWEN"; //		0x19f
        case KEY_VIDEOPHONE: return "KEY_VIDEOPHONE"; //		0x1a0	/* Media Select Video Phone */
        case KEY_GAMES: return "KEY_GAMES"; //		0x1a1	/* Media Select Games */
        case KEY_ZOOMIN: return "KEY_ZOOMIN"; //		0x1a2	/* AC Zoom In */
        case KEY_ZOOMOUT: return "KEY_ZOOMOUT"; //		0x1a3	/* AC Zoom Out */
        case KEY_ZOOMRESET: return "KEY_ZOOMRESET"; //		0x1a4	/* AC Zoom */
        case KEY_WORDPROCESSOR: return "KEY_WORDPROCESSOR"; //	0x1a5	/* AL Word Processor */
        case KEY_EDITOR: return "KEY_EDITOR"; //		0x1a6	/* AL Text Editor */
        case KEY_SPREADSHEET: return "KEY_SPREADSHEET"; //		0x1a7	/* AL Spreadsheet */
        case KEY_GRAPHICSEDITOR: return "KEY_GRAPHICSEDITOR"; //	0x1a8	/* AL Graphics Editor */
        case KEY_PRESENTATION: return "KEY_PRESENTATION"; //	0x1a9	/* AL Presentation App */
        case KEY_DATABASE: return "KEY_DATABASE"; //		0x1aa	/* AL Database App */
        case KEY_NEWS: return "KEY_NEWS"; //		0x1ab	/* AL Newsreader */
        case KEY_VOICEMAIL: return "KEY_VOICEMAIL"; //		0x1ac	/* AL Voicemail */
        case KEY_ADDRESSBOOK: return "KEY_ADDRESSBOOK"; //		0x1ad	/* AL Contacts/Address Book */
        case KEY_MESSENGER: return "KEY_MESSENGER"; //		0x1ae	/* AL Instant Messaging */
        case KEY_DISPLAYTOGGLE: return "KEY_DISPLAYTOGGLE"; //	0x1af	/* Turn display (LCD) on and off */
        case KEY_SPELLCHECK: return "KEY_SPELLCHECK"; //		0x1b0   /* AL Spell Check */
        case KEY_LOGOFF: return "KEY_LOGOFF"; //		0x1b1   /* AL Logoff */

        case KEY_DOLLAR: return "KEY_DOLLAR"; //		0x1b2
        case KEY_EURO: return "KEY_EURO"; //		0x1b3

        case KEY_FRAMEBACK: return "KEY_FRAMEBACK"; //		0x1b4	/* Consumer - transport controls */
        case KEY_FRAMEFORWARD: return "KEY_FRAMEFORWARD"; //	0x1b5
        case KEY_CONTEXT_MENU: return "KEY_CONTEXT_MENU"; //	0x1b6	/* GenDesc - system context menu */
        case KEY_MEDIA_REPEAT: return "KEY_MEDIA_REPEAT"; //	0x1b7	/* Consumer - transport control */
        case KEY_10CHANNELSUP: return "KEY_10CHANNELSUP"; //	0x1b8	/* 10 channels up (10+) */
        case KEY_10CHANNELSDOWN: return "KEY_10CHANNELSDOWN"; //	0x1b9	/* 10 channels down (10-) */
        case KEY_IMAGES: return "KEY_IMAGES"; //		0x1ba	/* AL Image Browser */
        case KEY_NOTIFICATION_CENTER: return "KEY_NOTIFICATION_CENTER"; //	0x1bc	/* Show/hide the notification center */
        case KEY_PICKUP_PHONE: return "KEY_PICKUP_PHONE"; //	0x1bd	/* Answer incoming call */
        case KEY_HANGUP_PHONE: return "KEY_HANGUP_PHONE"; //	0x1be	/* Decline incoming call */

        case KEY_DEL_EOL: return "KEY_DEL_EOL"; //		0x1c0
        case KEY_DEL_EOS: return "KEY_DEL_EOS"; //		0x1c1
        case KEY_INS_LINE: return "KEY_INS_LINE"; //		0x1c2
        case KEY_DEL_LINE: return "KEY_DEL_LINE"; //		0x1c3

        case KEY_FN: return "KEY_FN"; //			0x1d0
        case KEY_FN_ESC: return "KEY_FN_ESC"; //		0x1d1
        case KEY_FN_F1: return "KEY_FN_F1"; //		0x1d2
        case KEY_FN_F2: return "KEY_FN_F2"; //		0x1d3
        case KEY_FN_F3: return "KEY_FN_F3"; //		0x1d4
        case KEY_FN_F4: return "KEY_FN_F4"; //		0x1d5
        case KEY_FN_F5: return "KEY_FN_F5"; //		0x1d6
        case KEY_FN_F6: return "KEY_FN_F6"; //		0x1d7
        case KEY_FN_F7: return "KEY_FN_F7"; //		0x1d8
        case KEY_FN_F8: return "KEY_FN_F8"; //		0x1d9
        case KEY_FN_F9: return "KEY_FN_F9"; //		0x1da
        case KEY_FN_F10: return "KEY_FN_F10"; //		0x1db
        case KEY_FN_F11: return "KEY_FN_F11"; //		0x1dc
        case KEY_FN_F12: return "KEY_FN_F12"; //		0x1dd
        case KEY_FN_1: return "KEY_FN_1"; //		0x1de
        case KEY_FN_2: return "KEY_FN_2"; //		0x1df
        case KEY_FN_D: return "KEY_FN_D"; //		0x1e0
        case KEY_FN_E: return "KEY_FN_E"; //		0x1e1
        case KEY_FN_F: return "KEY_FN_F"; //		0x1e2
        case KEY_FN_S: return "KEY_FN_S"; //		0x1e3
        case KEY_FN_B: return "KEY_FN_B"; //		0x1e4
        case KEY_FN_RIGHT_SHIFT: return "KEY_FN_RIGHT_SHIFT"; //	0x1e5

        case KEY_BRL_DOT1: return "KEY_BRL_DOT1"; //		0x1f1
        case KEY_BRL_DOT2: return "KEY_BRL_DOT2"; //		0x1f2
        case KEY_BRL_DOT3: return "KEY_BRL_DOT3"; //		0x1f3
        case KEY_BRL_DOT4: return "KEY_BRL_DOT4"; //		0x1f4
        case KEY_BRL_DOT5: return "KEY_BRL_DOT5"; //		0x1f5
        case KEY_BRL_DOT6: return "KEY_BRL_DOT6"; //		0x1f6
        case KEY_BRL_DOT7: return "KEY_BRL_DOT7"; //		0x1f7
        case KEY_BRL_DOT8: return "KEY_BRL_DOT8"; //		0x1f8
        case KEY_BRL_DOT9: return "KEY_BRL_DOT9"; //		0x1f9
        case KEY_BRL_DOT10: return "KEY_BRL_DOT10"; //		0x1fa

        case KEY_NUMERIC_0: return "KEY_NUMERIC_0"; //		0x200	/* used by phones, remote controls, */
        case KEY_NUMERIC_1: return "KEY_NUMERIC_1"; //		0x201	/* and other keypads */
        case KEY_NUMERIC_2: return "KEY_NUMERIC_2"; //		0x202
        case KEY_NUMERIC_3: return "KEY_NUMERIC_3"; //		0x203
        case KEY_NUMERIC_4: return "KEY_NUMERIC_4"; //		0x204
        case KEY_NUMERIC_5: return "KEY_NUMERIC_5"; //		0x205
        case KEY_NUMERIC_6: return "KEY_NUMERIC_6"; //		0x206
        case KEY_NUMERIC_7: return "KEY_NUMERIC_7"; //		0x207
        case KEY_NUMERIC_8: return "KEY_NUMERIC_8"; //		0x208
        case KEY_NUMERIC_9: return "KEY_NUMERIC_9"; //		0x209
        case KEY_NUMERIC_STAR: return "KEY_NUMERIC_STAR"; //	0x20a
        case KEY_NUMERIC_POUND: return "KEY_NUMERIC_POUND"; //	0x20b
        case KEY_NUMERIC_A: return "KEY_NUMERIC_A"; //		0x20c	/* Phone key A - HUT Telephony 0xb9 */
        case KEY_NUMERIC_B: return "KEY_NUMERIC_B"; //		0x20d
        case KEY_NUMERIC_C: return "KEY_NUMERIC_C"; //		0x20e
        case KEY_NUMERIC_D: return "KEY_NUMERIC_D"; //		0x20f

        case KEY_CAMERA_FOCUS: return "KEY_CAMERA_FOCUS"; //	0x210
        case KEY_WPS_BUTTON: return "KEY_WPS_BUTTON"; //		0x211	/* WiFi Protected Setup key */

        case KEY_TOUCHPAD_TOGGLE: return "KEY_TOUCHPAD_TOGGLE"; //	0x212	/* Request switch touchpad on or off */
        case KEY_TOUCHPAD_ON: return "KEY_TOUCHPAD_ON"; //		0x213
        case KEY_TOUCHPAD_OFF: return "KEY_TOUCHPAD_OFF"; //	0x214

        case KEY_CAMERA_ZOOMIN: return "KEY_CAMERA_ZOOMIN"; //	0x215
        case KEY_CAMERA_ZOOMOUT: return "KEY_CAMERA_ZOOMOUT"; //	0x216
        case KEY_CAMERA_UP: return "KEY_CAMERA_UP"; //		0x217
        case KEY_CAMERA_DOWN: return "KEY_CAMERA_DOWN"; //		0x218
        case KEY_CAMERA_LEFT: return "KEY_CAMERA_LEFT"; //		0x219
        case KEY_CAMERA_RIGHT: return "KEY_CAMERA_RIGHT"; //	0x21a

        case KEY_ATTENDANT_ON: return "KEY_ATTENDANT_ON"; //	0x21b
        case KEY_ATTENDANT_OFF: return "KEY_ATTENDANT_OFF"; //	0x21c
        case KEY_ATTENDANT_TOGGLE: return "KEY_ATTENDANT_TOGGLE"; //	0x21d	/* Attendant call on or off */
        case KEY_LIGHTS_TOGGLE: return "KEY_LIGHTS_TOGGLE"; //	0x21e	/* Reading light on or off */

        case KEY_ALS_TOGGLE: return "KEY_ALS_TOGGLE"; //		0x230	/* Ambient light sensor */
        case KEY_ROTATE_LOCK_TOGGLE: return "KEY_ROTATE_LOCK_TOGGLE"; //	0x231	/* Display rotation lock */

        case KEY_BUTTONCONFIG: return "KEY_BUTTONCONFIG"; //		0x240	/* AL Button Configuration */
        case KEY_TASKMANAGER: return "KEY_TASKMANAGER"; //		0x241	/* AL Task/Project Manager */
        case KEY_JOURNAL: return "KEY_JOURNAL"; //		0x242	/* AL Log/Journal/Timecard */
        case KEY_CONTROLPANEL: return "KEY_CONTROLPANEL"; //		0x243	/* AL Control Panel */
        case KEY_APPSELECT: return "KEY_APPSELECT"; //		0x244	/* AL Select Task/Application */
        case KEY_SCREENSAVER: return "KEY_SCREENSAVER"; //		0x245	/* AL Screen Saver */
        case KEY_VOICECOMMAND: return "KEY_VOICECOMMAND"; //		0x246	/* Listening Voice Command */
        case KEY_ASSISTANT: return "KEY_ASSISTANT"; //		0x247	/* AL Context-aware desktop assistant */
        case KEY_KBD_LAYOUT_NEXT: return "KEY_KBD_LAYOUT_NEXT"; //	0x248	/* AC Next Keyboard Layout Select */
        case KEY_EMOJI_PICKER: return "KEY_EMOJI_PICKER"; //	0x249	/* Show/hide emoji picker (HUTRR101) */
        case KEY_DICTATE: return "KEY_DICTATE"; //		0x24a	/* Start or Stop Voice Dictation Session (HUTRR99) */

        case KEY_BRIGHTNESS_MIN: return "KEY_BRIGHTNESS_MIN"; //		0x250	/* Set Brightness to Minimum */
        case KEY_BRIGHTNESS_MAX: return "KEY_BRIGHTNESS_MAX"; //		0x251	/* Set Brightness to Maximum */

        case KEY_KBDINPUTASSIST_PREV: return "KEY_KBDINPUTASSIST_PREV"; //		0x260
        case KEY_KBDINPUTASSIST_NEXT: return "KEY_KBDINPUTASSIST_NEXT"; //		0x261
        case KEY_KBDINPUTASSIST_PREVGROUP: return "KEY_KBDINPUTASSIST_PREVGROUP"; //		0x262
        case KEY_KBDINPUTASSIST_NEXTGROUP: return "KEY_KBDINPUTASSIST_NEXTGROUP"; //		0x263
        case KEY_KBDINPUTASSIST_ACCEPT: return "KEY_KBDINPUTASSIST_ACCEPT"; //		0x264
        case KEY_KBDINPUTASSIST_CANCEL: return "KEY_KBDINPUTASSIST_CANCEL"; //		0x265

        /* Diagonal movement keys */
        case KEY_RIGHT_UP: return "KEY_RIGHT_UP"; //			0x266
        case KEY_RIGHT_DOWN: return "KEY_RIGHT_DOWN"; //			0x267
        case KEY_LEFT_UP: return "KEY_LEFT_UP"; //			0x268
        case KEY_LEFT_DOWN: return "KEY_LEFT_DOWN"; //			0x269

        case KEY_ROOT_MENU: return "KEY_ROOT_MENU"; //			0x26a /* Show Device's Root Menu */
        /* Show Top Menu of the Media (e.g. DVD) */
        case KEY_MEDIA_TOP_MENU: return "KEY_MEDIA_TOP_MENU"; //		0x26b
        case KEY_NUMERIC_11: return "KEY_NUMERIC_11"; //			0x26c
        case KEY_NUMERIC_12: return "KEY_NUMERIC_12"; //			0x26d
        /*
        * Toggle Audio Description: refers to an audio service that helps blind and
        * visually impaired consumers understand the action in a program. Note: in
        * some countries this is referred to as "Video Description".
        */
        case KEY_AUDIO_DESC: return "KEY_AUDIO_DESC"; //			0x26e
        case KEY_3D_MODE: return "KEY_3D_MODE"; //			0x26f
        case KEY_NEXT_FAVORITE: return "KEY_NEXT_FAVORITE"; //		0x270
        case KEY_STOP_RECORD: return "KEY_STOP_RECORD"; //			0x271
        case KEY_PAUSE_RECORD: return "KEY_PAUSE_RECORD"; //		0x272
        case KEY_VOD: return "KEY_VOD"; //				0x273 /* Video on Demand */
        case KEY_UNMUTE: return "KEY_UNMUTE"; //			0x274
        case KEY_FASTREVERSE: return "KEY_FASTREVERSE"; //			0x275
        case KEY_SLOWREVERSE: return "KEY_SLOWREVERSE"; //			0x276
        /*
        * Control a data application associated with the currently viewed channel,
        * e.g. teletext or data broadcast application (MHEG, MHP, HbbTV, etc.)
        */
        case KEY_DATA: return "KEY_DATA"; //			0x277
        case KEY_ONSCREEN_KEYBOARD: return "KEY_ONSCREEN_KEYBOARD"; //		0x278
        /* Electronic privacy screen control */
        case KEY_PRIVACY_SCREEN_TOGGLE: return "KEY_PRIVACY_SCREEN_TOGGLE"; //	0x279

        /* Select an area of screen to be copied */
        case KEY_SELECTIVE_SCREENSHOT: return "KEY_SELECTIVE_SCREENSHOT"; //	0x27a

        /*
        * Some keyboards have keys which do not have a defined meaning, these keys
        * are intended to be programmed / bound to macros by the user. For most
        * keyboards with these macro-keys the key-sequence to inject, or action to
        * take, is all handled by software on the host side. So from the kernel's
        * point of view these are just normal keys.
        *
        * The KEY_MACRO# codes below are intended for such keys, which may be labeled
        * e.g. G1-G18, or S1 - S30. The KEY_MACRO# codes MUST NOT be used for keys
        * where the marking on the key does indicate a defined meaning / purpose.
        *
        * The KEY_MACRO# codes MUST also NOT be used as fallback for when no existing
        * KEY_FOO define matches the marking / purpose. In this case a new KEY_FOO
        * define MUST be added.
        */
        case KEY_MACRO1: return "KEY_MACRO1"; //			0x290
        case KEY_MACRO2: return "KEY_MACRO2"; //			0x291
        case KEY_MACRO3: return "KEY_MACRO3"; //			0x292
        case KEY_MACRO4: return "KEY_MACRO4"; //			0x293
        case KEY_MACRO5: return "KEY_MACRO5"; //			0x294
        case KEY_MACRO6: return "KEY_MACRO6"; //			0x295
        case KEY_MACRO7: return "KEY_MACRO7"; //			0x296
        case KEY_MACRO8: return "KEY_MACRO8"; //			0x297
        case KEY_MACRO9: return "KEY_MACRO9"; //			0x298
        case KEY_MACRO10: return "KEY_MACRO10"; //			0x299
        case KEY_MACRO11: return "KEY_MACRO11"; //			0x29a
        case KEY_MACRO12: return "KEY_MACRO12"; //			0x29b
        case KEY_MACRO13: return "KEY_MACRO13"; //			0x29c
        case KEY_MACRO14: return "KEY_MACRO14"; //			0x29d
        case KEY_MACRO15: return "KEY_MACRO15"; //			0x29e
        case KEY_MACRO16: return "KEY_MACRO16"; //			0x29f
        case KEY_MACRO17: return "KEY_MACRO17"; //			0x2a0
        case KEY_MACRO18: return "KEY_MACRO18"; //			0x2a1
        case KEY_MACRO19: return "KEY_MACRO19"; //			0x2a2
        case KEY_MACRO20: return "KEY_MACRO20"; //			0x2a3
        case KEY_MACRO21: return "KEY_MACRO21"; //			0x2a4
        case KEY_MACRO22: return "KEY_MACRO22"; //			0x2a5
        case KEY_MACRO23: return "KEY_MACRO23"; //			0x2a6
        case KEY_MACRO24: return "KEY_MACRO24"; //			0x2a7
        case KEY_MACRO25: return "KEY_MACRO25"; //			0x2a8
        case KEY_MACRO26: return "KEY_MACRO26"; //			0x2a9
        case KEY_MACRO27: return "KEY_MACRO27"; //			0x2aa
        case KEY_MACRO28: return "KEY_MACRO28"; //			0x2ab
        case KEY_MACRO29: return "KEY_MACRO29"; //			0x2ac
        case KEY_MACRO30: return "KEY_MACRO30"; //			0x2ad

        /*
        * Some keyboards with the macro-keys described above have some extra keys
        * for controlling the host-side software responsible for the macro handling:
        * -A macro recording start/stop key. Note that not all keyboards which emit
        *  KEY_MACRO_RECORD_START will also emit KEY_MACRO_RECORD_STOP if
        *  KEY_MACRO_RECORD_STOP is not advertised, then KEY_MACRO_RECORD_START
        *  should be interpreted as a recording start/stop toggle;
        * -Keys for switching between different macro (pre)sets, either a key for
        *  cycling through the configured presets or keys to directly select a preset.
        */
        case KEY_MACRO_RECORD_START: return "KEY_MACRO_RECORD_START"; //		0x2b0
        case KEY_MACRO_RECORD_STOP: return "KEY_MACRO_RECORD_STOP"; //		0x2b1
        case KEY_MACRO_PRESET_CYCLE: return "KEY_MACRO_PRESET_CYCLE"; //		0x2b2
        case KEY_MACRO_PRESET1: return "KEY_MACRO_PRESET1"; //		0x2b3
        case KEY_MACRO_PRESET2: return "KEY_MACRO_PRESET2"; //		0x2b4
        case KEY_MACRO_PRESET3: return "KEY_MACRO_PRESET3"; //		0x2b5

        /*
        * Some keyboards have a buildin LCD panel where the contents are controlled
        * by the host. Often these have a number of keys directly below the LCD
        * intended for controlling a menu shown on the LCD. These keys often don't
        * have any labeling so we just name them KEY_KBD_LCD_MENU#
        */
        case KEY_KBD_LCD_MENU1: return "KEY_KBD_LCD_MENU1"; //		0x2b8
        case KEY_KBD_LCD_MENU2: return "KEY_KBD_LCD_MENU2"; //		0x2b9
        case KEY_KBD_LCD_MENU3: return "KEY_KBD_LCD_MENU3"; //		0x2ba
        case KEY_KBD_LCD_MENU4: return "KEY_KBD_LCD_MENU4"; //		0x2bb
        case KEY_KBD_LCD_MENU5: return "KEY_KBD_LCD_MENU5"; //		0x2bc
        default: return "UNDEFINED";
    }
}
const char* event_typ(){
    return "NONE";
}
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
#define EV_TYPE_0 0
#define EV_TYPE_KEYBOARD 1
#define EV_TYPE_MOUSE 2
#define EV_TYPE_4 4
void printEvents(FILE *file) {
    size_t sz = sizeof(struct input_event);
    struct input_event ev;
    size_t bytesRead;
    while ((bytesRead = fread(&ev, 1, sz, file)) > 0) {
        char* evt_type="unknown";
        int dx=0;
        int dy=0;
        int dz=0;
        switch (ev.type ) {
            case EV_TYPE_0: continue; break;
            case EV_TYPE_KEYBOARD:
                if ( ev.value == 0 ){
                    evt_type = "key_up";
                    state.keys[ev.code]=0;
                } else {
                    evt_type = "key_down";
                    state.keys[ev.code]=ev.code;
                }
                //// printf(
                ////     "{\"time\":{\"seconds\":%llu,\"nanos\":%09llu},\"num\":%d_%03d_%04d,\"event_type\":\"%s\",\"key\":{\"code\":%d,\"name\":\"%s\"},\"dx\":%d,\"dy\":%d}\n",
                ////     ev.time.tv_sec,
                ////     ev.time.tv_usec,
                ////     ev.type,
                ////     ev.code,
                ////     ev.value,
                ////     evt_type,
                ////     ev.code,
                ////     event_key_code_to_string(ev.code),
                ////     dx,
                ////     dy
                //// );
            break;
            case EV_TYPE_MOUSE: 
                switch(ev.code) {
                    case 0: evt_type="move_x";
                        dx=(int)ev.value;
                        dy=0;
                        dz=0;
                    break;
                    case 1: evt_type="move_y";
                        dx=0;
                        dy=(int)ev.value;
                        dz=0;
                    break;
                    case 8: 
                        if ( (int)ev.value < 0) {
                            evt_type="scroll_down";
                            dz=-1;
                            state.dz=-1;
                        }else {
                            evt_type="scroll_up";
                            dz=1;
                        }
                    break;
                    default: continue;break;
                }
                //// printf(
                ////     "{\"time\":{\"seconds\":%llu,\"nanos\":%09llu},\"num\":%d_%03d_%04d,\"event_type\":\"%s\",\"key\":null,\"dx\":%d,\"dy\":%d}\n",
                ////     ev.time.tv_sec,
                ////     ev.time.tv_usec,
                ////     ev.type,
                ////     ev.code,
                ////     ev.value,
                ////     evt_type,
                ////     dx,
                ////     dy
                //// );
                break;
            case EV_TYPE_4: continue; break;
        }
        state.x+=dx;
        state.dx=dx;
        state.y+=dy;
        state.dy=dy;
        state.z+=dz;
        state.dz=dz;
        input_state__print(state);
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
    printEvent(file);

    fclose(file);
    enableInputEcho();

    return 0;
}
