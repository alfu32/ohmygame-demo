module ohmygame

import time


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
			frame: time.now()
		}],
	}
	return level
}
