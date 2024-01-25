module ohmygame

import term.ui as tui
import os
import term.termios



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
pub fn (mut kb Keyboard) init() Keyboard {
	println("using input stream ${kb.location}")
	kb.file = os.open(kb.location) or {
		panic("file ${kb.location} not found")
	}
	return kb
}
pub fn (mut kb Keyboard) close() Keyboard {
	kb.file.close()
	return kb
}


pub fn (mut kb Keyboard) dequeue_events() []InputEvent {
	mut events := []InputEvent{}

	for {
		mut iev := InputEvent{}
		kb.file.read_struct[InputEvent](mut iev) or {
			break
		}
		events << iev
	}
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
	println("found ${kb.events.len}")
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
pub fn (kb Keyboard) to_str() string {
	kbd:="`1234567890-=\n\tasdfghjkl;'\n     zxcvbnm,./"
	mut r:=""
	for k in kbd.bytes() {
		chr := [k].bytestr()
		if k==13 || k==32 {
			r+=chr
		} else {
			code := u16(int(char_to_keycode(chr)))
			if kb.pressed[code] != 0 {
				r += "${get_background(Color.red)}${chr}\x1b[0m"
			} else {
				r += "${get_background(Color.green)}${chr}\x1b[0m"
			}
		}
	}
	return r
}

pub struct InputEvent{
	pub mut:
	seconds u64
	nanos u64
	typ u16
	code u16
	value u32
}

pub fn (ev InputEvent) get_char() string {
	code := match ev.code {
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
		47 { '_0' }
		48 { '_1' }
		49 { '_2' }
		50 { '_3' }
		51 { '_4' }
		52 { '_5' }
		53 { '_6' }
		54 { '_7' }
		55 { '_8' }
		56 { '_9' }
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
		else { '0' }
	}
	return code
}
pub fn char_to_keycode(code string) tui.KeyCode {
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
pub fn string_to_keycodes(list string) []tui.KeyCode {
	return list.split(",").map(char_to_keycode)
}
pub fn keycode_to_char(e tui.Event) u8 {
	code := match e.code {
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
		.insert { '0' }
		.delete { '0' }
		.up { '0' }
		.down { '0' }
		.right { '0' }
		.left { '0' }
		.page_up { '0' }
		.page_down { '0' }
		.home { '0' }
		.end { '0' }
		.f1 { '0' }
		.f2 { '0' }
		.f3 { '0' }
		.f4 { '0' }
		.f5 { '0' }
		.f6 { '0' }
		.f7 { '0' }
		.f8 { '0' }
		.f9 { '0' }
		.f10 { '0' }
		.f11 { '0' }
		.f12 { '0' }
		.f13 { '0' }
		.f14 { '0' }
		.f15 { '0' }
		.f16 { '0' }
		.f17 { '0' }
		.f18 { '0' }
		.f19 { '0' }
		.f20 { '0' }
		.f21 { '0' }
		.f22 { '0' }
		.f23 { '0' }
		.f24 { '0' }
		else { '0' }
	}
	return code[0]
}
