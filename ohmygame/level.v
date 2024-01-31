module ohmygame


@[heap]
struct Level{
	pub  mut:
	scenes []Scene
}

pub fn level_create() &Level{
	mut level:=&Level{
		scenes:[Scene{
			objects:[]&Entity{}
			canvas:drawing_context_2d_create(144,45," ")
			frame: input_event_time_now()
		}],
	}
	return level
}
