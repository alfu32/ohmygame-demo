module ohmygame

import rand

@[heap]
pub struct Entity{
	pub mut:
	instance_id string//  = rand.uuid_v4()
	type_name string
	shape Shape
}


pub fn create_player_ship(figure string) &Entity {
	mut ent := &Entity {
		instance_id: rand.uuid_v4()
		shape: Shape{
			anchor: Point{2,3,4}
		}
	}
	ent.shape.set_figure(figure,figure,figure)
	return ent
}
