module ohmygame

import os
import term.termios


pub fn test_kbd_raw(){
	// kbd := Keyboard{
	// 	device:
	// 	ev: InputEvent{}
	// 	pressed: {}
	// }
	pipename := "/tmp/kbev/events"
	mut f := os.open(pipename) or {
		panic("file ${pipename} not found")
	}
	a:= f.read_bytes(24)
	println(a)
	mut iev := InputEvent{}
	f.read_struct[InputEvent](mut iev) or {
		panic("reading struct not working")
	}
	println(iev)
	f.close()
}
pub fn test_kbd_init(){
	mut kbd := Keyboard{location: "/tmp/kbev/events"}
	println(kbd)
	dump(kbd)
	assert kbd.file.fd == 0
	assert kbd.file.is_opened == false
	kbd.init()
	println(kbd)
	dump(kbd)
	assert kbd.file.fd != 0
	assert kbd.file.is_opened == true
	kbd.close()
	println(kbd)
	dump(kbd)
	assert kbd.file.fd != 0
	assert kbd.file.is_opened == false
}
pub fn test_kbd_dequeue_events(){
	mut kbd := Keyboard{location: "/tmp/kbev/events"}
	kbd.init()
	evts:=kbd.dequeue_events()
	println(evts)
	kbd.close()
}
pub fn test_kbd_fetch_events(){
	mut kbd := Keyboard{location: "/tmp/kbev/events"}
	kbd.init()
	kbd=kbd.refresh_state()
	println(kbd)
	kbd.close()
}

fn test_termios() {
	mut old_state := termios.Termios{}
	if termios.tcgetattr(0, mut old_state) != 0 {
		//return os.last_error()
		panic(os.last_error())
	}
	defer {
		// restore the old terminal state:
		termios.tcsetattr(0, C.TCSANOW, mut old_state)
	}

	mut state := termios.Termios{}
	if termios.tcgetattr(0, mut state) != 0 {
		//return os.last_error()
		panic(os.last_error())
	}

	state.c_lflag &= termios.invert(u32(C.ICANON) | u32(C.ECHO))
	termios.tcsetattr(0, C.TCSANOW, mut state)

}
