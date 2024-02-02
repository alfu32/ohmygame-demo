module ohmygame


@[heap]
pub struct Level{
	pub  mut:
	scenes []&Scene
	current_index int
	current_scene &Scene
}

pub fn level_create(width int,height int, scenes []&Scene) &Level{
	mut level:=&Level{
		scenes:scenes,
		current_index:0,
		current_scene:scenes[0],
	}
	return level
}


fn print_debug(s string){
	if false {
		println(s)
	}
}
pub fn (mut level Level) render(mut t Terminal, kbd Keyboard){
	print_debug("level.current_scene.run_actions(omg.input_event_time_now(),kbd)")
	level.current_scene.run_actions(input_event_time_now(),kbd)
	print_debug("level.current_scene.do_collisions()")
	level.current_scene.do_collisions()
	/////////// print_debug("level.current_scene.remove_dead_entities()")
	/////////// level.current_scene.remove_dead_entities()
	print_debug("level.current_scene.update_canvas()")
	level.current_scene.update_canvas()
	/// print("\r${kbd.pressed.keys()}")
	print_debug("t.clear()")
	t.clear()
	print_debug("level.current_scene.canvas.render_to_terminal(mut &t)")
	level.current_scene.canvas.render_to_terminal(mut &t)
	/// s := level.current_scene.canvas.render_to_string()
	/// println(s)
}

pub fn (mut level Level) is_finished(kbd &Keyboard) bool {
	if level.current_scene.is_finished() {
			level.current_index+=1
			level.current_scene=level.scenes[level.current_index]
			return false // will continue
	} else {
		return false // will continue
	}
}
