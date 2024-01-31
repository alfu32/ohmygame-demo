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

pub fn (mut level Level) is_finished(kbd &Keyboard) bool {
	if level.current_scene.is_finished() {
			level.current_index+=1
			level.current_scene=level.scenes[level.current_index]
			return false // will continue
	} else {
		return false // will continue
	}
}
