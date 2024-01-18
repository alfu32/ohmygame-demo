module ohmygame


pub fn normalized_figure(figure string) [][]u8 {
	lines:=figure.replace_char(9,32,4).split("\n")
	mut width:=lines[0].len
	for line in lines {
		if line.len > width {width = line.len}
	}
	return lines.map(fn[width](line string) []u8 {
		return pad_end(line,u32(width)," ").bytes()
	})
}
pub fn buffer_rotate2d_clockwise(figure [][]u8) [][]u8 {
	width:=figure[0].len
	height:=figure.len
	mut new_figure := [][]u8{len: width, init: []u8{len: height,init: 32}}
	for y in 1..height+1 {
		for x in 0..width {
			new_figure[x][y-1]=figure[height-y][x]
		}
	}
	return new_figure//.split("\n").map(it.bytes())
}
pub fn buffer_shift_circular_horizontally(figure [][]u8) [][]u8 {
	width:=figure[0].len
	height:=figure.len
	mut new_figure := [][]u8{len: height, init: []u8{len: width,init: 32}}
	for x in 0..width {
		for y in 0..height {
			new_figure[y][x]=figure[y][(x+1)%width]
		}
	}
	return new_figure//.split("\n").map(it.bytes())
}
pub fn buffer_shift_circular_vertically(figure [][]u8) [][]u8 {
	width:=figure[0].len
	height:=figure.len
	mut new_figure := [][]u8{len: height, init: []u8{len: width,init: 32}}
	for y in 0..height {
		new_figure[y]=figure[(y+1)%height]
	}
	return new_figure//.split("\n").map(it.bytes())
}

pub struct Shape{
	pub mut:
	anchor Point
	size Point
	direction Point = Point{1,0,0}
	figure [][]u8
	background [][]u8
	foreground [][]u8
}
pub fn (mut sh Shape) set_figure(fig string,color string,background string) Shape {
	sh.figure = trim_indent(normalized_figure(fig)," ".bytes())
	height:=sh.figure.len
	width:=sh.figure[0].len
	sh.size=Point{x:width,y:height,z:1}
	sh.background=trim_indent(normalized_figure(background)," ".bytes()).map(it.map(it%8))
	sh.foreground=trim_indent(normalized_figure(color)," ".bytes()).map(it.map(it%8))
	return sh
}
pub fn (mut sh Shape) rotate_figure() {
	sh.figure=buffer_rotate2d_clockwise(sh.figure)
	sh.background=buffer_rotate2d_clockwise(sh.background)
	sh.foreground=buffer_rotate2d_clockwise(sh.foreground)

	if sh.direction.x==1 {
		sh.direction.x=0
		sh.direction.y=-1
	} else if sh.direction.y==-1 {
		sh.direction.x=-1
		sh.direction.y=0
	} else if sh.direction.x==-1 {
		sh.direction.x=0
		sh.direction.y=1
	} else if sh.direction.y==1 {
		sh.direction.x=1
		sh.direction.y=0
	}
	x:=sh.size.x
	sh.size.x=sh.size.y
	sh.size.y=x
}

pub fn (sh Shape) get_bounding_rectangle() Rectangle {
	return Rectangle{
		anchor:sh.anchor.copy()
		size: sh.size.copy()
	}
}
pub fn (sh Shape) str() string{
	return "
{
type: Shape,
anchor: ${sh.anchor.str()}
size: ${sh.size.str()}
direction: ${sh.direction.str()}
figure:BUFFER>>>
${buffer_to_string(sh.figure)}BUFFER
background:BUFFER>>>
${buffer_to_numbers(sh.background)}BUFFER
foreground:BUFFER>>>
${buffer_to_numbers(sh.foreground)}BUFFER
}
	".trim_indent()
} 