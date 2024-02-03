module ohmygame

import math
import utils

pub struct DrawingContext2D{
	pub:
		fill string
	pub mut:
		window Rectangle
		buffer [][]u8
		background [][]u8
		foreground [][]u8
}

pub fn drawing_context_2d_create(width int, height int,fill string) DrawingContext2D {
	vp := DrawingContext2D{
		fill: fill
		window: Rectangle{
			anchor: Point{0,0,0}
			size: Point{width,height,0}
		}
		buffer: [][]u8{len: height, init: []u8{len: width,init: fill[0]}}
		background: [][]u8{len: height, init: []u8{len: width,init: 0}}
		foreground: [][]u8{len: height, init: []u8{len: width,init: 0}}
	}
	return vp
}

pub fn (mut vp DrawingContext2D) resize(width int,height int) {
	vp.window.size.x=width
	vp.window.size.y=height
	vp.buffer = [][]u8{len: height, init: []u8{len: width,init: vp.fill[0]}}
	vp.background = [][]u8{len: height, init: []u8{len: width,init: 0}}
	vp.foreground = [][]u8{len: height, init: []u8{len: width,init: 0}}

}
pub fn (mut vp DrawingContext2D) print_shape(sh Shape) {
	mut vp_lines:=vp.buffer.map(it[0..it.len])
	mut vp_background:=vp.background.map(it[0..it.len])
	mut vp_foreground:=vp.foreground.map(it[0..it.len])
	sh_lines:=sh.figure.map(it[0..it.len])
	sh_background:=sh.background.map(it[0..it.len])
	sh_foreground:=sh.foreground.map(it[0..it.len])
	vpr:=vp.window
	shr:=sh.get_bounding_rectangle()
	sh_corner:=shr.corner()
	vp_corner:=vpr.corner()
	startx:=math.max(shr.anchor.x,vpr.anchor.x)
	starty:=math.max(shr.anchor.y,vpr.anchor.y)
	endx:=math.min(sh_corner.x,vp_corner.x)
	endy:=math.min(sh_corner.y,vp_corner.y)
	for y in starty..endy {
		sh_line:=sh_lines[y-shr.anchor.y]
		sh_bkg:=sh_background[y-shr.anchor.y]
		sh_fgr:=sh_foreground[y-shr.anchor.y]
		for x in startx..endx {
			// println("shape ${x} ${y}")
			if sh_line[x-shr.anchor.x]>32 {
				vp_lines[y][x]=sh_line[x-shr.anchor.x]
				// println("sh_background ${x} ${y}")
				if sh_bkg[x-shr.anchor.x] > 0  {
					vp_background[y][x]=sh_bkg[x-shr.anchor.x]
				}
				// println("sh_foreground ${x} ${y}")
				if sh_fgr[x-shr.anchor.x] > 0 {
					vp_foreground[y][x]=sh_fgr[x-shr.anchor.x]
				}
			}
		}
	}
	// vp.buffer=vp_lines
	// vp.background=vp_background
	// vp.foreground=vp_foreground

}
pub fn (mut vp DrawingContext2D) clear() {
	vp.buffer=[][]u8{len: vp.window.size.y, init: []u8{len: vp.window.size.x,init: 32}}
	vp.background=[][]u8{len: vp.window.size.y, init: []u8{len: vp.window.size.x,init: 0}}
	vp.foreground=[][]u8{len: vp.window.size.y, init: []u8{len: vp.window.size.x,init: 0}}
}
pub fn (vp DrawingContext2D) print_at(x int, y int, figure string) {

}
pub fn (mut canvas DrawingContext2D) render_to_terminal(mut t &Terminal) {
	border := "-".repeat(canvas.window.size.x)
	t.clear()
	t.putstr("+${border}+\n",Color.black,Color.white)
	for y in 0..canvas.window.size.y {
		t.putstr("#",Color.black,Color.white)
		for x in 0..canvas.window.size.x {
			char_at:= [canvas.buffer[y][x]].bytestr()
			t.putstr(char_at,color_from_munber(canvas.background[y][x]),color_from_munber(canvas.foreground[y][x]))
		}
		t.putstr("#\n",Color.black,Color.white)
	}
	t.putstr("+${border}+",Color.black,Color.white)
	t.flush()
}
pub fn (mut canvas DrawingContext2D) render_to_string() string{
	mut t := Terminal{}
	canvas.render_to_terminal(mut t)
	return t.str()
}

pub fn (vp DrawingContext2D) str() string{
	return "{
type: DrawingContext2D,
window: ${vp.window.str()},
buffer:BUFFER>>>
${utils.buffer_to_string(vp.buffer)}BUFFER
background:BUFFER>>>
${utils.buffer_to_numbers(vp.background)}BUFFER
foreground:BUFFER>>>
${utils.buffer_to_numbers(vp.foreground)}BUFFER
}"
}


