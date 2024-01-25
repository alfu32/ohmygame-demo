module ohmygame

import term.ui as tui
pub enum Color{
	black
	red
	green
	yellow
	blue
	magenta
	cyan
	white
}
pub fn color_from_munber(n u8) Color {
	return match n {
		0 { Color.black }
		1 { Color.red }
		2 { Color.green }
		3 { Color.yellow }
		4 { Color.blue }
		5 { Color.magenta }
		6 { Color.cyan }
		7 { Color.white }
		else { Color.black }
	}
}
pub fn (c Color) value() u8 {
	return match c {
		.black { 0 }
		.red { 1 }
		.green { 2 }
		.yellow { 3 }
		.blue { 4 }
		.magenta { 5 }
		.cyan { 6 }
		.white { 7 }
	}
}

@[heap]
pub struct Terminal{
	pub mut:
		last_color Color
		last_background Color
		stream string  = "\x1b[3J\x1b[0,0H"
		context &tui.Context = unsafe{ nil }
}
pub fn get_color(c Color) string {
	return "\x1b[${30+c.value()}m"
}
pub fn get_background(c Color) string {
	return "\x1b[${40+c.value()}m"
}
pub fn (mut self Terminal) color(c Color) {
	if self.last_color != c {
		self.stream = "${self.stream}\x1b[0m${get_color(c)}"
		self.last_color = c
	}
}
pub fn (mut self Terminal) background(c Color) {
	if self.last_background != c {
		self.stream = "${self.stream}\x1b[0m${get_background(c)}"
		self.last_background = c
	}
}
pub fn (mut self Terminal) putchar(chr u8, background Color, color Color) {
	self.putstr([chr].bytestr(),background,color)
}
pub fn (mut self Terminal) putstr(str string, background Color, color Color) {
	self.background(background)
	self.color(color)
	self.stream = "${self.stream}${str}"
}
pub fn (mut self Terminal) clear() {
	self.background(Color.black)
	self.color(Color.white)
	self.stream = "\x1b[3J\x1b[0,0H"
}
pub fn (self Terminal) str() string {
	return "${self.stream}"
}
pub fn (self Terminal) dump_str() []u8 {
	return self.stream.bytes()
}
