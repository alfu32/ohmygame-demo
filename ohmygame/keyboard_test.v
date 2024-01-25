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
}

fn test_termios() {
	fd:=os.stdin().fd
	mut original_term := termios.Termios{}
	termios.tcgetattr(fd, mut original_term)
	println(original_term)

	mut silent_term := original_term
	silent_term.c_lflag &= termios.invert(10)
	termios.tcsetattr(fd, 0, mut silent_term)

	mut check_term := termios.Termios{}
	termios.tcgetattr(fd, mut check_term)
	assert check_term.c_lflag == silent_term.c_lflag
	dump(check_term)

	termios.tcsetattr(fd, 0xffff, mut original_term)

	termios.tcgetattr(fd, mut check_term)
	assert check_term.c_lflag == original_term.c_lflag
	dump(check_term)
}
