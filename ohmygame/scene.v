module ohmygame

import term.ui as tui

pub struct Scene{
	pub mut:
	objects []&Entity
	canvas DrawingContext2D
	frame u64
}

pub fn (mut sc Scene) next(keys []tui.KeyCode) {
	sc.frame+=1
	for mut ent in sc.objects{
		ent.next(mut sc, keys)
	}
}
pub fn (mut sc Scene) animate() {
	sc.canvas.clear()
	for ent in sc.objects{
		//if sc.canvas.window.intersects(ent.shape.get_bounding_rectangle()) {
			sc.canvas.print_shape(ent.shape)
		//}
	}
}
pub fn (mut sc Scene) render(mut rendering_context tui.Context) {
	rendering_context.clear()
	for y in 0..sc.canvas.window.size.y {
		for x in 0..sc.canvas.window.size.x {
			charat:=[sc.canvas.buffer[y][x]].bytestr()
			rendering_context.set_bg_color(color_codes[sc.canvas.background[y][x]])
			rendering_context.set_color(color_codes[sc.canvas.foreground[y][x]])
			rendering_context.draw_text(x+sc.canvas.window.anchor.x,y+sc.canvas.window.anchor.y,charat)
		}
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
