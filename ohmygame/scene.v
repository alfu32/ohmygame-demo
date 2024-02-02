module ohmygame

pub struct Scene{
	pub mut:
	objects []&Entity
	canvas DrawingContext2D
	frame InputEventTime
	is_finished bool
}

pub fn scene_create(width int,height int) Scene {
	return Scene{
		objects: []
		canvas: drawing_context_2d_create(width,height," ")
		frame: input_event_time_now()
		is_finished: false
	}
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
