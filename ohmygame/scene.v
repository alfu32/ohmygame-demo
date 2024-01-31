module ohmygame

pub struct Scene{
	pub mut:
	objects []&Entity
	canvas DrawingContext2D
	frame InputEventTime
	is_finished bool
}


pub fn (mut sc Scene) add_object(e &Entity) {
	sc.objects << e
}

pub fn (mut sc Scene) is_finished() bool {
	return false
	// return sc.is_finished
}

pub fn (mut sc Scene) update_canvas() {
	sc.canvas.clear()
	for ent in sc.objects{
		//if sc.canvas.window.intersects(ent.shape.get_bounding_rectangle()) {
			sc.canvas.print_shape(ent.shape)
		//}
	}
}
pub fn (mut sc Scene)run_actions( frame InputEventTime, keyboard &Keyboard ){
	for mut e in sc.objects {
		e.run_actions(frame,keyboard)
	}
}
pub fn (mut sc Scene)remove_dead_entities(){
	sc.objects=sc.objects.filter(fn(e &Entity) bool {
		return e.life > 0
	})
}
pub fn (mut sc Scene)do_collisions( ){
	for i in 0..sc.objects.len {
		if i == sc.objects.len-1 {
			break
		}
		for j in i..sc.objects.len {
			mut a := sc.objects[i]
			mut b := sc.objects[j]
			if a.shape.get_bounding_rectangle().intersects(b.shape.get_bounding_rectangle()) {
				b.life-=a.power
				a.life-=b.power
			}
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
