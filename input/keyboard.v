module input

import os
import term.termios
import term





@[heap]
pub struct Keyboard{
	pub:
	location string
	pub mut:
	file os.File
	events []InputEvent
	pressed map[KeyCode]InputEvent
	stdin os.File
	original_term termios.Termios
	silent_term termios.Termios

	stdin_at_startup u32
	use_alternate_buffer bool
	hide_cursor bool

	// get the standard input handle
	stdin_handle voidptr
	stdout_handle voidptr
}
fn copy_termios(src termios.Termios) termios.Termios {
	// mut cpcc:=[termios.cclen]termios.Cc{}
	//mut cpreserved :=[3]u32{}
	//cpreserved[0]=src.reserved[0]
	//cpreserved[1]=src.reserved[1]
	//cpreserved[2]=src.reserved[2]
	//for k,cc in src.c_cc {
	//	cpcc[k]=cc
	//}
	return termios.Termios{
		c_iflag: src.c_iflag
		c_oflag: src.c_oflag
		c_cflag: src.c_cflag
		c_lflag: src.c_lflag
		c_cc: src.c_cc
		// reserved: cpreserved
		c_ispeed: src.c_ispeed
		c_ospeed: src.c_ospeed
	}
}
pub fn (mut kb Keyboard) init() Keyboard {
	// setting terminal not to show stdin
	// rendering stdin silent
	termios.tcgetattr(0, mut kb.original_term);
	kb.silent_term = copy_termios(kb.original_term)
	kb.silent_term.c_lflag &= int(4294967285)
	kb.silent_term.c_ispeed = 1
	kb.silent_term.c_ospeed = 1
	termios.tcsetattr(0, 0, mut kb.silent_term);

	println("using input stream ${kb.location}")
	term.hide_cursor()
	return kb
}
pub fn (mut kb Keyboard) close() Keyboard {
	term.show_cursor()
	kb.original_term.c_lflag |= int(12)
	termios.tcsetattr(0, 0, mut kb.original_term);
	return kb
}


pub fn (mut kb Keyboard) dequeue_events() []InputEvent {
	last_event:= if kb.events.len > 0 { kb.events.last() } else {
		InputEvent{}
	}
	//println("opening ${kb.location}")
	kb.file = os.open(kb.location) or {
		panic("file ${kb.location} not found")
	}

	mut events := []InputEvent{}

	for {
		mut iev := InputEvent{}
		kb.file.read_struct[InputEvent](mut iev) or {
			break
		}
		if iev.event_timestamp > last_event.event_timestamp {
			// iev.event_timestamp.seconds = iev.event_timestamp.seconds >> 8
			// iev.event_timestamp.nanos = iev.event_timestamp.nanos >> 8
			iev.typ = iev.typ >> 0
			iev.code = iev.code >> 0
			iev.value = iev.value >> 0
			events << iev
		}
	}
	//println("closing ${kb.location}")
	kb.file.close()
	return events
}
pub fn (mut kb Keyboard) flush_file() {

	kb.file = os.create(kb.location) or {
		panic("file ${kb.location} could not be opened for writing ${err}")
	}

	kb.file.write([]) or {
		println("could not flush ${kb.location}")
	}
	kb.file.close()
}
pub fn (mut self Keyboard) refresh_state() Keyboard {
	events := self.dequeue_events()
	//println("found ${kb.events.len}")
	for ev in events {
		self.pressed[key_code_from_int(ev.code >> 8)]=ev
	}
	self.events = []
	self.events << events
	return self
}
pub fn (mut self Keyboard) get_pressed_keys() []KeyCode {
	mut kb:= []KeyCode{}
	for k,v in self.pressed {
		if v.value != 0 {
			kb << k
		}
	}
	return kb
}
pub fn (self Keyboard) any_is_pressed(keys []KeyCode) bool {
	for k,v in self.pressed {
		if v.value != 0 && k in keys{
			return true
		}
	}
	return false
}
pub fn (self Keyboard) is_pressed(key KeyCode) bool {
	return self.pressed[key].value != 0
}
pub fn (self Keyboard) all_are_pressed(keys []KeyCode) bool {
	for kn in keys {
		if self.pressed[kn].value == 0  {
			return false
		}
	}
	return true
}
// pub fn (kb Keyboard) to_str() string {
// 	kbd:="`1234567890-=\n\tasdfghjkl;'\n     zxcvbnm,./"
// 	mut r:=""
// 	for k in kbd.bytes() {
// 		chr := [k].bytestr()
// 		if k==13 || k==32 {
// 			r+=chr
// 		} else {
// 			code := u16(int(key_name_to_keycode(chr)))
// 			if kb.pressed[code] != 0 {
// 				r += "${get_background(Color.red)}${chr}\x1b[0m"
// 			} else {
// 				r += "${get_background(Color.green)}${chr}\x1b[0m"
// 			}
// 		}
// 	}
// 	return r
// }

pub struct InputEvent{
	pub mut:
	event_timestamp InputEventTime
	typ u16
	code u16
	value u32
}
pub fn (ie InputEvent) str() string {
	return "InputEvent{timestamp:${ie.event_timestamp.hex()},typ:${ie.typ},code:${ie.code},value:${ie.value}}"
}
pub fn (ie InputEvent) hex() string {
	return "InputEvent{T ${ie.event_timestamp.hex()} TY ${ie.typ:04x} C ${ie.code:04X} V ${ie.value:04x}}"
}
pub fn (ev InputEvent) key_name() string {
	return key_code_from_int(ev.code).str()
}
pub fn (ev InputEvent) key_code() KeyCode {
	return key_code_from_int(ev.code)
}
pub fn key_code_from_int(code i32) KeyCode {
	mut enum_value:=KeyCode.reserved
	enum_value = unsafe{KeyCode(code)}
	return enum_value
}
pub fn keys_to_names(codes []i32) []KeyCode {
	return codes.map(key_code_from_int)
}

pub fn keycode_to_strings(list []KeyCode) []string {
	return list.map(keycode_to_keyname)
}
pub fn keycode_to_keyname(code KeyCode) string {
	return "${code}"
}
