module ohmygame

import time

pub struct Scene{
	pub mut:
	objects []&Entity
	canvas DrawingContext2D
	frame time.Time
}


pub fn (mut sc Scene) add_object(e &Entity) {
	sc.objects << e
}
pub fn (mut sc Scene) update() {
	sc.canvas.clear()
	for ent in sc.objects{
		//if sc.canvas.window.intersects(ent.shape.get_bounding_rectangle()) {
			sc.canvas.print_shape(ent.shape)
		//}
	}
}
pub fn (mut sc Scene) render_to_terminal(mut t &Terminal) {
	border := "-".repeat(sc.canvas.window.size.x)
	t.clear()
	t.putstr("+${border}+\n",Color.black,Color.white)
	for y in 0..sc.canvas.window.size.y {
		t.putstr("#",Color.black,Color.white)
		for x in 0..sc.canvas.window.size.x {
			charat:= [sc.canvas.buffer[y][x]].bytestr()
			t.putstr(charat,color_from_munber(sc.canvas.background[y][x]),color_from_munber(sc.canvas.foreground[y][x]))
		}
		t.putstr("#\n",Color.black,Color.white)
	}
	t.putstr("+${border}+",Color.black,Color.white)
}
pub fn (mut sc Scene) render_to_string() string{
	mut t := Terminal{}
	sc.render_to_terminal(mut t)
	return t.str()
}
