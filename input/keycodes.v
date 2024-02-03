module input


pub enum KeyCode{
	reserved
	esc
	number_1
	number_2
	number_3
	number_4
	number_5
	number_6
	number_7
	number_8
	number_9
	number_0
	minus
	equal
	backspace
	tab
	q
	w
	e
	r
	t
	y
	u
	i
	o
	p
	leftbrace
	rightbrace
	enter
	leftctrl
	a
	s
	d
	f
	g
	h
	j
	k
	l
	semicolon
	apostrophe
	grave
	leftshift
	backslash
	z
	x
	c
	v
	b
	n
	m
	comma
	dot
	slash
	rightshift
	kpasterisk
	leftalt
	space
	capslock
	f1
	f2
	f3
	f4
	f5
	f6
	f7
	f8
	f9
	f10
	numlock
	scrolllock
	kp7
	kp8
	kp9
	kpminus
	kp4
	kp5
	kp6
	kpplus
	kp1
	kp2
	kp3
	kp0
	kpdot
	zenkakuhankaku = 85
	k102nd
	f11
	f12
	ro
	katakana
	hiragana
	henkan
	katakanahiragana
	muhenkan
	kpjpcomma
	kpenter
	rightctrl
	kpslash
	sysrq
	rightalt
	linefeed
	home
	up
	pageup
	left
	right
	end
	down
	pagedown
	insert
	delete
	macro
	mute
	volumedown
	volumeup
	power	//  SC System Power Down */
	kpequal
	kpplusminus
	pause
	scale	//  AL Compiz Scale (Expose) */
	kpcomma
	hangeul
	hanja
	yen
	leftmeta
	rightmeta
	compose
	stop	//  AC Stop */
	again
	props	//  AC Properties */
	undo	//  AC Undo */
	front
	copy	//  AC Copy */
	open	//  AC Open */
	paste	//  AC Paste */
	find	//  AC Search */
	cut	//  AC Cut */
	help	//  AL Integrated Help Center */
	menu	//  Menu (show menu) */
	calc	//  AL Calculator */
	setup
	sleep	//  SC System Sleep */
	wakeup	//  System Wake Up */
	file	//  AL Local Machine Browser */
	sendfile
	deletefile
	xfer
	prog1
	prog2
	www	//  AL Internet Browser */
	msdos
	coffee	//  AL Terminal Lock/Screensaver */
	// KEY_COFFEE
	rotate_display	//  Display orientation for e.g. tablets */
	// KEY_ROTATE_DISPLAY
	cyclewindows
	mail
	bookmarks	//  AC Bookmarks */
	computer
	back	//  AC Back */
	forward	//  AC Forward */
	closecd
	ejectcd
	ejectclosecd
	nextsong
	playpause
	previoussong
	stopcd
	record
	rewind
	phone	//  Media Select Telephone */
	iso
	config	//  AL Consumer Control Configuration */
	homepage	//  AC Home */
	refresh	//  AC Refresh */
	exit	//  AC Exit */
	move
	edit
	scrollup
	scrolldown
	kpleftparen
	kprightparen
	new	//  AC New */
	redo	//  AC Redo/Repeat */
	f13
	f14
	f15
	f16
	f17
	f18
	f19
	f20
	f21
	f22
	f23
	f24
	playcd = 200
	pausecd
	prog3
	prog4
	all_applications	//  AC Desktop Show All Applications */
	// KEY_ALL_APPLICATIONS
	suspend
	close	//  AC Close */
	play
	fastforward
	bassboost
	print	//  AC Print */
	hp
	camera
	sound
	question
	email
	chat
	search
	connect
	finance	//  AL Checkbook/Finance */
	sport
	shop
	alterase
	cancel	//  AC Cancel */
	brightnessdown
	brightnessup
	media
	switchvideomode// Cycle between available video
	kbdillumtoggle = 228
	kbdillumdown = 229
	kbdillumup = 230
	send = 231	//  AC Send */
	reply = 232	//  AC Reply */
	forwardmail = 233	//  AC Forward Msg */
	save = 234	//  AC Save */
	documents = 235
	battery = 236
	bluetooth = 237
	wlan = 238
	uwb = 239
	unknown = 240
	video_next = 241	//  drive next video source */
	video_prev = 242	//  drive previous video source */
	brightness_cycle = 243	//  brightness up, after max is min */
	brightness_auto = 244	//  Set Auto Brightness: manual
	// brightness_zero = KEY_BRIGHTNESS_AUTO
	display_off = 245	//  display device to off state */
	wwan = 246	//  Wireless WAN (LTE, UMTS, GSM, etc.) */
	// wimax = KEY_WWAN
	rfkill = 247	//  Key that controls all radios */
	micmute = 248	//  Mute / unmute the microphone */
	ok = 0x160
	select_key = 0x161
	goto_key = 0x162
	clear = 0x163
	power2 = 0x164
	option = 0x165
	info = 0x166	//  AL OEM Features/Tips/Tutorial */
	time = 0x167
	vendor = 0x168
	archive = 0x169
	program = 0x16a	//  Media Select Program Guide */
	channel = 0x16b
	favorites = 0x16c
	epg = 0x16d
	pvr = 0x16e	//  Media Select Home */
	mhp = 0x16f
	language = 0x170
	title = 0x171
	subtitle = 0x172
	angle = 0x173
	full_screen = 0x174	//  AC View Toggle */
	// zoom = KEY_FULL_SCREEN
	mode = 0x175
	keyboard = 0x176
	aspect_ratio = 0x177	//  HUTRR37: Aspect */
	// screen = KEY_ASPECT_RATIO
	pc = 0x178	//  Media Select Computer */
	tv = 0x179	//  Media Select TV */
	tv2 = 0x17a	//  Media Select Cable */
	vcr = 0x17b	//  Media Select VCR */
	vcr2 = 0x17c	//  VCR Plus */
	sat = 0x17d	//  Media Select Satellite */
	sat2 = 0x17e
	cd = 0x17f	//  Media Select CD */
	tape = 0x180	//  Media Select Tape */
	radio = 0x181
	tuner = 0x182	//  Media Select Tuner */
	player = 0x183
	text = 0x184
	dvd = 0x185	//  Media Select DVD */
	aux = 0x186
	mp3 = 0x187
	audio = 0x188	//  AL Audio Browser */
	video = 0x189	//  AL Movie Browser */
	directory = 0x18a
	list = 0x18b
	memo = 0x18c	//  Media Select Messages */
	calendar = 0x18d
	red = 0x18e
	green = 0x18f
	yellow = 0x190
	blue = 0x191
	channelup = 0x192	//  Channel Increment */
	channeldown = 0x193	//  Channel Decrement */
	first = 0x194
	last = 0x195	//  Recall Last */
	ab = 0x196
	next = 0x197
	restart = 0x198
	slow = 0x199
	shuffle = 0x19a
	break_key = 0x19b
	previous = 0x19c
	digits = 0x19d
	teen = 0x19e
	twen = 0x19f
	videophone = 0x1a0	//  Media Select Video Phone */
	games = 0x1a1	//  Media Select Games */
	zoomin = 0x1a2	//  AC Zoom In */
	zoomout = 0x1a3	//  AC Zoom Out */
	zoomreset = 0x1a4	//  AC Zoom */
	wordprocessor = 0x1a5	//  AL Word Processor */
	editor = 0x1a6	//  AL Text Editor */
	spreadsheet = 0x1a7	//  AL Spreadsheet */
	graphicseditor = 0x1a8	//  AL Graphics Editor */
	presentation = 0x1a9	//  AL Presentation App */
	database = 0x1aa	//  AL Database App */
	news = 0x1ab	//  AL Newsreader */
	voicemail = 0x1ac	//  AL Voicemail */
	addressbook = 0x1ad	//  AL Contacts/Address Book */
	messenger = 0x1ae	//  AL Instant Messaging */
	displaytoggle = 0x1af	//  Turn display (LCD) on and off */
	// brightness_toggle = KEY_DISPLAYTOGGLE
	spellcheck = 0x1b0   //  AL Spell Check */
	logoff = 0x1b1   //  AL Logoff */
	dollar = 0x1b2
	euro = 0x1b3
	frameback = 0x1b4	//  Consumer - transport controls */
	frameforward = 0x1b5
	context_menu = 0x1b6	//  GenDesc - system context menu */
	media_repeat = 0x1b7	//  Consumer - transport control */
	k10channelsup = 0x1b8	//  10 channels up (10+) */
	k10channelsdown = 0x1b9	//  10 channels down (10-) */
	images = 0x1ba	//  AL Image Browser */
	notification_center = 0x1bc	//  Show/hide the notification center */
	pickup_phone = 0x1bd	//  Answer incoming call */
	hangup_phone = 0x1be	//  Decline incoming call */
	del_eol = 0x1c0
	del_eos = 0x1c1
	ins_line = 0x1c2
	del_line = 0x1c3
	fn_key = 0x1d0
	fn_esc = 0x1d1
	fn_f1 = 0x1d2
	fn_f2 = 0x1d3
	fn_f3 = 0x1d4
	fn_f4 = 0x1d5
	fn_f5 = 0x1d6
	fn_f6 = 0x1d7
	fn_f7 = 0x1d8
	fn_f8 = 0x1d9
	fn_f9 = 0x1da
	fn_f10 = 0x1db
	fn_f11 = 0x1dc
	fn_f12 = 0x1dd
	fn_1 = 0x1de
	fn_2 = 0x1df
	fn_d = 0x1e0
	fn_e = 0x1e1
	fn_f = 0x1e2
	fn_s = 0x1e3
	fn_b = 0x1e4
	fn_right_shift = 0x1e5
	brl_dot1 = 0x1f1
	brl_dot2 = 0x1f2
	brl_dot3 = 0x1f3
	brl_dot4 = 0x1f4
	brl_dot5 = 0x1f5
	brl_dot6 = 0x1f6
	brl_dot7 = 0x1f7
	brl_dot8 = 0x1f8
	brl_dot9 = 0x1f9
	brl_dot10 = 0x1fa
	numeric_0 = 0x200	//  used by phones, remote controls, */
	numeric_1 = 0x201	//  and other keypads */
	numeric_2 = 0x202
	numeric_3 = 0x203
	numeric_4 = 0x204
	numeric_5 = 0x205
	numeric_6 = 0x206
	numeric_7 = 0x207
	numeric_8 = 0x208
	numeric_9 = 0x209
	numeric_star = 0x20a
	numeric_pound = 0x20b
	numeric_a = 0x20c	//  Phone key A - HUT Telephony 0xb9 */
	numeric_b = 0x20d
	numeric_c = 0x20e
	numeric_d = 0x20f
	camera_focus = 0x210
	wps_button = 0x211	//  WiFi Protected Setup key */
	touchpad_toggle = 0x212	//  Request switch touchpad on or off */
	touchpad_on = 0x213
	touchpad_off = 0x214
	camera_zoomin = 0x215
	camera_zoomout = 0x216
	camera_up = 0x217
	camera_down = 0x218
	camera_left = 0x219
	camera_right = 0x21a
	attendant_on = 0x21b
	attendant_off = 0x21c
	attendant_toggle = 0x21d	//  Attendant call on or off */
	lights_toggle = 0x21e	//  Reading light on or off */
	als_toggle = 0x230	//  Ambient light sensor */
	rotate_lock_toggle = 0x231	//  Display rotation lock */
	buttonconfig = 0x240	//  AL Button Configuration */
	taskmanager = 0x241	//  AL Task/Project Manager */
	journal = 0x242	//  AL Log/Journal/Timecard */
	controlpanel = 0x243	//  AL Control Panel */
	appselect = 0x244	//  AL Select Task/Application */
	screensaver = 0x245	//  AL Screen Saver */
	voicecommand = 0x246	//  Listening Voice Command */
	assistant = 0x247	//  AL Context-aware desktop assistant */
	kbd_layout_next = 0x248	//  AC Next Keyboard Layout Select */
	emoji_picker = 0x249	//  Show/hide emoji picker (HUTRR101) */
	dictate = 0x24a	//  Start or Stop Voice Dictation Session (HUTRR99) */
	camera_access_enable = 0x24b	//  Enables programmatic access to camera devices. (HUTRR72) */
	camera_access_disable = 0x24c	//  Disables programmatic access to camera devices. (HUTRR72) */
	camera_access_toggle = 0x24d	//  Toggles the current state of the camera access control. (HUTRR72) */
	brightness_min = 0x250	//  Set Brightness to Minimum */
	brightness_max = 0x251	//  Set Brightness to Maximum */
	kbdinputassist_prev = 0x260
	kbdinputassist_next = 0x261
	kbdinputassist_prevgroup = 0x262
	kbdinputassist_nextgroup = 0x263
	kbdinputassist_accept = 0x264
	kbdinputassist_cancel = 0x265
	right_up = 0x266
	right_down = 0x267
	left_up = 0x268
	left_down = 0x269
	root_menu = 0x26a //  Show Device's Root Menu */
	media_top_menu = 0x26b
	numeric_11 = 0x26c
	numeric_12 = 0x26d
	audio_desc = 0x26e
	k3d_mode = 0x26f
	next_favorite = 0x270
	stop_record = 0x271
	pause_record = 0x272
	vod = 0x273 //  Video on Demand */
	unmute = 0x274
	fastreverse = 0x275
	slowreverse = 0x276
	data = 0x277
	onscreen_keyboard = 0x278
	privacy_screen_toggle = 0x279
	selective_screenshot = 0x27a
	next_element = 0x27b
	previous_element = 0x27c
	autopilot_engage_toggle = 0x27d
	mark_waypoint = 0x27e
	sos = 0x27f
	nav_chart = 0x280
	fishing_chart = 0x281
	single_range_radar = 0x282
	dual_range_radar = 0x283
	radar_overlay = 0x284
	traditional_sonar = 0x285
	clearvu_sonar = 0x286
	sidevu_sonar = 0x287
	nav_info = 0x288
	brightness_menu = 0x289
	macro1 = 0x290
	macro2 = 0x291
	macro3 = 0x292
	macro4 = 0x293
	macro5 = 0x294
	macro6 = 0x295
	macro7 = 0x296
	macro8 = 0x297
	macro9 = 0x298
	macro10 = 0x299
	macro11 = 0x29a
	macro12 = 0x29b
	macro13 = 0x29c
	macro14 = 0x29d
	macro15 = 0x29e
	macro16 = 0x29f
	macro17 = 0x2a0
	macro18 = 0x2a1
	macro19 = 0x2a2
	macro20 = 0x2a3
	macro21 = 0x2a4
	macro22 = 0x2a5
	macro23 = 0x2a6
	macro24 = 0x2a7
	macro25 = 0x2a8
	macro26 = 0x2a9
	macro27 = 0x2aa
	macro28 = 0x2ab
	macro29 = 0x2ac
	macro30 = 0x2ad
	macro_record_start = 0x2b0
	macro_record_stop = 0x2b1
	macro_preset_cycle = 0x2b2
	macro_preset1 = 0x2b3
	macro_preset2 = 0x2b4
	macro_preset3 = 0x2b5
	kbd_lcd_menu1 = 0x2b8
	kbd_lcd_menu2 = 0x2b9
	kbd_lcd_menu3 = 0x2ba
	kbd_lcd_menu4 = 0x2bb
	kbd_lcd_menu5 = 0x2bc
	// min_interesting = 113
}
const keys_max = 0x2ff
const keys_cnt = 0x300
