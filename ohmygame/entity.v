module ohmygame

import rand
import time


pub enum EntityType {
	friend
	foe
	background_picture
	background_interactive
}
pub type EntityActionFn = fn ( e Entity, scene Scene, frame time.Time, keyboard Keyboard )
pub struct EntityAction {
	max_interval time.Time
}
@[heap]
pub struct Entity{
	pub mut:
	instance_id string//  = rand.uuid_v4()
	user string
	shape Shape
	actions []EntityAction
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
