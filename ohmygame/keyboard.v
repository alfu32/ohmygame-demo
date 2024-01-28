module ohmygame

import term.ui as tui
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
	pressed map[i32]i32
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
			events << iev
		}
	}
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
	mut kb:=&self
	kb.events=kb.dequeue_events()
	//println("found ${kb.events.len}")
	for ev in kb.events {
		if ev.typ == 0x01 {
			if ev.value == 0 {
				kb.pressed[ev.code]=0
			} else {
				kb.pressed[ev.code]=ev.code
			}
		}
	}
	return kb
}
pub fn (mut self Keyboard) get_pressed_keys() []i32 {
	mut kb:= []i32{}
	for k,v in self.pressed {
		if v != 0 {
			kb << k
		}
	}
	return kb
}
pub fn (mut self Keyboard) any_is_pressed(key_names []string) bool {
	for k,v in self.pressed {
		if v != 0 && key_name(k) in key_names{
			return true
		}
	}
	return false
}
pub fn (mut self Keyboard) all_are_pressed(key_names []string) bool {
	for kn in key_names {
		if self.pressed[key_code(kn)] == 0  {
			return false
		}
	}
	return true
}
pub fn (kb Keyboard) to_str() string {
	kbd:="`1234567890-=\n\tasdfghjkl;'\n     zxcvbnm,./"
	mut r:=""
	for k in kbd.bytes() {
		chr := [k].bytestr()
		if k==13 || k==32 {
			r+=chr
		} else {
			code := u16(int(key_name_to_keycode(chr)))
			if kb.pressed[code] != 0 {
				r += "${get_background(Color.red)}${chr}\x1b[0m"
			} else {
				r += "${get_background(Color.green)}${chr}\x1b[0m"
			}
		}
	}
	return r
}

pub struct InputEventTime{
	seconds u64
	nanos u64
}
pub fn (a InputEventTime) <(b InputEventTime) bool {
	return a.seconds < b.seconds ||
		( a.seconds==b.seconds && a.nanos<b.nanos)
}
pub fn (a InputEventTime) ==(b InputEventTime) bool {
	return ( a.seconds==b.seconds && a.nanos==b.nanos)
}

pub struct InputEvent{
	pub mut:
	event_timestamp InputEventTime
	typ u16
	code u16
	value u32
}

pub fn key_code(name string) i32 {
	return match name {
		 'null' { 0 }
		 'tab','\t' { 9 }
		 'enter','\n' { 10 }
		 'space',' ' { 27 }
		 'backspace' { 32 }
		 'exclamation','!' { 127 }
		 'double_quote','"' { 33 }
		 'hashtag','#' { 34 }
		 'dollar','$' { 35 }
		 'percent','%' { 36 }
		 'ampersand','&' { 37 }
		 "single_quote","'" { 38 }
		 'left_paren','(' { 39 }
		 'right_paren',')' { 40 }
		 'asterisk','*' { 41 }
		 'plus','+' { 42 }
		 'comma',',' { 43 }
		 'minus','-' { 44 }
		 'period','.' { 45 }
		 'slash','/' { 46 }
		 '0' { 47 }
		 '1' { 48 }
		 '2' { 49 }
		 '3' { 50 }
		 '4' { 51 }
		 '5' { 52 }
		 '6' { 53 }
		 '7' { 54 }
		 '8' { 55 }
		 '9' { 56 }
		 'colon',':' { 57 }
		 'semicolon',';' { 58 }
		 'less_than','<' { 59 }
		 'equal','=' { 60 }
		 'greater_than','>' { 61 }
		 'question_mark','?' { 62 }
		 'at','@' { 63 }
		 'a','A' { 64 }
		 'b','B' { 97 }
		 'c','C' { 98 }
		 'd','D' { 99 }
		 'e','E' { 100 }
		 'f','F' { 101 }
		 'g','G' { 102 }
		 'h','H' { 103 }
		 'i','I' { 104 }
		 'j','J' { 105 }
		 'k','K' { 106 }
		 'l','L' { 107 }
		 'm','M' { 108 }
		 'n','N' { 109 }
		 'o','O' { 110 }
		 'p','P' { 111 }
		 'q','Q' { 112 }
		 'r','R' { 113 }
		 's','S' { 114 }
		 't','T' { 115 }
		 'u','U' { 116 }
		 'v','V' { 117 }
		 'w','W' { 118 }
		 'x','X' { 119 }
		 'y','Y' { 120 }
		 'z','Z' { 121 }
		 'left_square_bracket','[' { 122 }
		 'backslash','\\' { 91 }
		 'right_square_bracket',']' { 92 }
		 'caret','^' { 93 }
		 'underscore','_' { 94 }
		 'backtick','`' { 95 }
		 'left_curly_bracket','{' { 96 }
		 'vertical_bar','|' { 123 }
		 'right_curly_bracket','}' { 124 }
		 'tilde','~' { 125 }
		 'insert' { 126 }
		 'delete' { 260 }
		 'up' { 261 }
		 'down' { 262 }
		 'right' { 263 }
		 'left' { 264 }
		 'page_up' { 265 }
		 'page_down' { 266 }
		 'home' { 267 }
		 'end' { 268 }
		 'f1' { 269 }
		 'f2' { 290 }
		 'f3' { 291 }
		 'f4' { 292 }
		 'f5' { 293 }
		 'f6' { 294 }
		 'f7' { 295 }
		 'f8' { 296 }
		 'f9' { 297 }
		 'f10' { 298 }
		 'f11' { 299 }
		 'f12' { 300 }
		 'f13' { 301 }
		 'f14' { 302 }
		 'f15' { 303 }
		 'f16' { 304 }
		 'f17' { 305 }
		 'f18' { 306 }
		 'f19' { 307 }
		 'f20' { 308 }
		 'f21' { 309 }
		 'f22' { 310 }
		 'f23' { 311 }
		 'f24' { 312 }
		else { -1 }
	}
}
pub fn (ev InputEvent) key_name() string {
	return key_name(ev.code)
}
pub fn key_name(code i32) string {
	return match code {
		0 { 'null' }
		9 { 'tab' }
		10 { 'enter' }
		27 { 'space' }
		32 { 'backspace' }
		127 { 'exclamation' }
		33 { 'double_quote' }
		34 { 'hashtag' }
		35 { 'dollar' }
		36 { 'percent' }
		37 { 'ampersand' }
		38 { "single_quote" }
		39 { 'left_paren' }
		40 { 'right_paren' }
		41 { 'asterisk' }
		42 { 'plus' }
		43 { 'comma' }
		44 { 'minus' }
		45 { 'period' }
		46 { 'slash' }
		47 { '0' }
		48 { '1' }
		49 { '2' }
		50 { '3' }
		51 { '4' }
		52 { '5' }
		53 { '6' }
		54 { '7' }
		55 { '8' }
		56 { '9' }
		57 { 'colon' }
		58 { 'semicolon' }
		59 { 'less_than' }
		60 { 'equal' }
		61 { 'greater_than' }
		62 { 'question_mark' }
		63 { 'at' }
		64 { 'a' }
		97 { 'b' }
		98 { 'c' }
		99 { 'd' }
		100 { 'e' }
		101 { 'f' }
		102 { 'g' }
		103 { 'h' }
		104 { 'i' }
		105 { 'j' }
		106 { 'k' }
		107 { 'l' }
		108 { 'm' }
		109 { 'n' }
		110 { 'o' }
		111 { 'p' }
		112 { 'q' }
		113 { 'r' }
		114 { 's' }
		115 { 't' }
		116 { 'u' }
		117 { 'v' }
		118 { 'w' }
		119 { 'x' }
		120 { 'y' }
		121 { 'z' }
		122 { 'left_square_bracket' }
		91 { 'backslash' }
		92 { 'right_square_bracket' }
		93 { 'caret' }
		94 { 'underscore' }
		95 { 'backtick' }
		96 { 'left_curly_bracket' }
		123 { 'vertical_bar' }
		124 { 'right_curly_bracket' }
		125 { 'tilde' }
		126 { 'insert' }
		260 { 'delete' }
		261 { 'up' }
		262 { 'down' }
		263 { 'right' }
		264 { 'left' }
		265 { 'page_up' }
		266 { 'page_down' }
		267 { 'home' }
		268 { 'end' }
		269 { 'f1' }
		290 { 'f2' }
		291 { 'f3' }
		292 { 'f4' }
		293 { 'f5' }
		294 { 'f6' }
		295 { 'f7' }
		296 { 'f8' }
		297 { 'f9' }
		298 { 'f10' }
		299 { 'f11' }
		300 { 'f12' }
		301 { 'f13' }
		302 { 'f14' }
		303 { 'f15' }
		304 { 'f16' }
		305 { 'f17' }
		306 { 'f18' }
		307 { 'f19' }
		308 { 'f20' }
		309 { 'f21' }
		310 { 'f22' }
		311 { 'f23' }
		312 { 'f24' }
		else { 'key_${code}' }
	}
}
pub fn keys_to_names(codes []i32) []string {
	return codes.map(key_name)
}
/// pub fn names_to_keys(key_names []string) []u16 {
/// 	return key_names.map(key_code)
/// }
pub fn key_name_to_keycode(code string) tui.KeyCode {
	kc := match code {
		'\0' { tui.KeyCode.null }
		'\t' { tui.KeyCode.tab }
		'\n' { tui.KeyCode.enter }
		' ' { tui.KeyCode.space }
		'backspace' { tui.KeyCode.backspace }
		'!' { tui.KeyCode.exclamation }
		'"' { tui.KeyCode.double_quote }
		'#' { tui.KeyCode.hashtag }
		'$' { tui.KeyCode.dollar }
		'%' { tui.KeyCode.percent }
		'&' { tui.KeyCode.ampersand }
		"'" { tui.KeyCode.single_quote }
		'(' { tui.KeyCode.left_paren }
		')' { tui.KeyCode.right_paren }
		'*' { tui.KeyCode.asterisk }
		'+' { tui.KeyCode.plus }
		',' { tui.KeyCode.comma }
		'-' { tui.KeyCode.minus }
		'.' { tui.KeyCode.period }
		'/' { tui.KeyCode.slash }
		'0' { tui.KeyCode._0 }
		'1' { tui.KeyCode._1 }
		'2' { tui.KeyCode._2 }
		'3' { tui.KeyCode._3 }
		'4' { tui.KeyCode._4 }
		'5' { tui.KeyCode._5 }
		'6' { tui.KeyCode._6 }
		'7' { tui.KeyCode._7 }
		'8' { tui.KeyCode._8 }
		'9' { tui.KeyCode._9 }
		':' { tui.KeyCode.colon }
		';' { tui.KeyCode.semicolon }
		'<' { tui.KeyCode.less_than }
		'=' { tui.KeyCode.equal }
		'>' { tui.KeyCode.greater_than }
		'?' { tui.KeyCode.question_mark }
		'@' { tui.KeyCode.at }
		'a' { tui.KeyCode.a }
		'b' { tui.KeyCode.b }
		'c' { tui.KeyCode.c }
		'd' { tui.KeyCode.d }
		'e' { tui.KeyCode.e }
		'f' { tui.KeyCode.f }
		'g' { tui.KeyCode.g }
		'h' { tui.KeyCode.h }
		'i' { tui.KeyCode.i }
		'j' { tui.KeyCode.j }
		'k' { tui.KeyCode.k }
		'l' { tui.KeyCode.l }
		'm' { tui.KeyCode.m }
		'n' { tui.KeyCode.n }
		'o' { tui.KeyCode.o }
		'p' { tui.KeyCode.p }
		'q' { tui.KeyCode.q }
		'r' { tui.KeyCode.r }
		's' { tui.KeyCode.s }
		't' { tui.KeyCode.t }
		'u' { tui.KeyCode.u }
		'v' { tui.KeyCode.v }
		'w' { tui.KeyCode.w }
		'x' { tui.KeyCode.x }
		'y' { tui.KeyCode.y }
		'z' { tui.KeyCode.z }
		'[' { tui.KeyCode.left_square_bracket }
		'\\' { tui.KeyCode.backslash }
		']' { tui.KeyCode.right_square_bracket }
		'^' { tui.KeyCode.caret }
		'_' { tui.KeyCode.underscore }
		'`' { tui.KeyCode.backtick }
		'{' { tui.KeyCode.left_curly_bracket }
		'|' { tui.KeyCode.vertical_bar }
		'}' { tui.KeyCode.right_curly_bracket }
		'~' { tui.KeyCode.tilde }
		'insert' { tui.KeyCode.insert }
		'delete' { tui.KeyCode.delete }
		'up' { tui.KeyCode.up }
		'down' { tui.KeyCode.down }
		'right' { tui.KeyCode.right }
		'left' { tui.KeyCode.left }
		'page_up' { tui.KeyCode.page_up }
		'page_down' { tui.KeyCode.page_down }
		'home' { tui.KeyCode.home }
		'end' { tui.KeyCode.end }
		'f1' { tui.KeyCode.f1 }
		'f2' { tui.KeyCode.f2 }
		'f3' { tui.KeyCode.f3 }
		'f4' { tui.KeyCode.f4 }
		'f5' { tui.KeyCode.f5 }
		'f6' { tui.KeyCode.f6 }
		'f7' { tui.KeyCode.f7 }
		'f8' { tui.KeyCode.f8 }
		'f9' { tui.KeyCode.f9 }
		'f10' { tui.KeyCode.f10 }
		'f11' { tui.KeyCode.f11 }
		'f12' { tui.KeyCode.f12 }
		'f13' { tui.KeyCode.f13 }
		'f14' { tui.KeyCode.f14 }
		'f15' { tui.KeyCode.f15 }
		'f16' { tui.KeyCode.f16 }
		'f17' { tui.KeyCode.f17 }
		'f18' { tui.KeyCode.f18 }
		'f19' { tui.KeyCode.f19 }
		'f20' { tui.KeyCode.f20 }
		'f21' { tui.KeyCode.f21 }
		'f22' { tui.KeyCode.f22 }
		'f23' { tui.KeyCode.f23 }
		'f24' { tui.KeyCode.f24 }
		else { tui.KeyCode.null }
	}
	return kc
}
pub fn strings_to_keycodes(list []string) []tui.KeyCode {
	return list.map(key_name_to_keycode)
}
pub fn keycode_to_strings(list []tui.KeyCode) []string {
	return list.map(keycode_to_keyname)
}
pub fn keycode_to_keyname(e tui.KeyCode) string {
	return match code {
		.null { '\0' }
		.tab { '\t' }
		.enter { '\n' }
		.space { ' ' }
		.backspace { '0' }
		.exclamation { '!' }
		.double_quote { '"' }
		.hashtag { '#' }
		.dollar { '$' }
		.percent { '%' }
		.ampersand { '&' }
		.single_quote { "'" }
		.left_paren { '(' }
		.right_paren { ')' }
		.asterisk { '*' }
		.plus { '+' }
		.comma { ',' }
		.minus { '-' }
		.period { '.' }
		.slash { '/' }
		._0 { '0' }
		._1 { '1' }
		._2 { '2' }
		._3 { '3' }
		._4 { '4' }
		._5 { '5' }
		._6 { '6' }
		._7 { '7' }
		._8 { '8' }
		._9 { '9' }
		.colon { ':' }
		.semicolon { ';' }
		.less_than { '<' }
		.equal { '=' }
		.greater_than { '>' }
		.question_mark { '?' }
		.at { '@' }
		.a { 'a' }
		.b { 'b' }
		.c { 'c' }
		.d { 'd' }
		.e { 'e' }
		.f { 'f' }
		.g { 'g' }
		.h { 'h' }
		.i { 'i' }
		.j { 'j' }
		.k { 'k' }
		.l { 'l' }
		.m { 'm' }
		.n { 'n' }
		.o { 'o' }
		.p { 'p' }
		.q { 'q' }
		.r { 'r' }
		.s { 's' }
		.t { 't' }
		.u { 'u' }
		.v { 'v' }
		.w { 'w' }
		.x { 'x' }
		.y { 'y' }
		.z { 'z' }
		.left_square_bracket { '[' }
		.backslash { '\\' }
		.right_square_bracket { ']' }
		.caret { '_' }
		.underscore { '_' }
		.backtick { '`' }
		.left_curly_bracket { '{' }
		.vertical_bar { '|' }
		.right_curly_bracket { '}' }
		.tilde { '~' }
		.insert { 'insert' }
		.delete { 'delete' }
		.up { 'up' }
		.down { 'down' }
		.right { 'right' }
		.left { 'left' }
		.page_up { 'page_up' }
		.page_down { 'page_down' }
		.home { 'home' }
		.end { 'end' }
		.f1 { 'f1' }
		.f2 { 'f2' }
		.f3 { 'f3' }
		.f4 { 'f4' }
		.f5 { 'f5' }
		.f6 { 'f6' }
		.f7 { 'f7' }
		.f8 { 'f8' }
		.f9 { 'f9' }
		.f10 { 'f10' }
		.f11 { 'f11' }
		.f12 { 'f12' }
		.f13 { 'f13' }
		.f14 { 'f14' }
		.f15 { 'f15' }
		.f16 { 'f16' }
		.f17 { 'f17' }
		.f18 { 'f18' }
		.f19 { 'f19' }
		.f20 { 'f20' }
		.f21 { 'f21' }
		.f22 { 'f22' }
		.f23 { 'f23' }
		.f24 { 'f24' }
		else { 'key_${code}}' }
	}
}
