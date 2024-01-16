module ohmygame

import arrays

pub struct Shape{
	pub mut:
	anchor Point
	figure string
	direction Point = Point{1,0,0}
}

pub fn (sh Shape) clean_figure() []string {
	return sh.figure.trim_indent().split("\n").map(it.replace_char("\t".bytes()[0],32,4))
}
pub fn (sh Shape) normalized_figure() []string {
	lines := sh.clean_figure()
	width:= arrays.fold[string, int](
		lines, 0,
		fn (r int, t string) int {
			if t.len>r {return t.len} else {return r}
		}
	)
	return lines.map(fn[width](line string) string {
		return pad_end(line,u32(width)," ")
	})
}
pub fn (mut sh Shape) rotate_figure() string {
	figure := sh.normalized_figure()
	br:=sh.get_bounding_rectangle()
	width:=br.size.x
	height:=br.size.y
	//println(figure)
	//println("width:${width},height:${width}")
	mut new_figure := "\n"
	for x in 0..width {
		for y in 1..height {
			byte_at_xy:=figure[height-y-1][x]
			char_at_xy:=[byte_at_xy].bytestr()
			//print(char_at_xy)
			new_figure="${new_figure}${char_at_xy}"
		}
		//print("\n")
		new_figure="${new_figure}\n"
	}
	new_figure="${new_figure}\n"
	sh.figure=new_figure
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
	return new_figure
}

pub fn (sh Shape) get_bounding_rectangle() Rectangle {
	lines := sh.normalized_figure()
	height := lines.len
	width:= arrays.fold[string, int](
		lines, 0,
		fn (r int, t string) int {
			if t.len>r {return t.len} else {return r}
		}
	)
	return Rectangle{
		anchor:sh.anchor.copy()
		size: Point{width,height,1}
	}
}