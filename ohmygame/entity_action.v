module ohmygame

import input

pub enum EntityType {
	friend
	foe
	background_picture
	background_interactive
}
pub type EntityActionFn = fn ( mut e &Entity, mut scene &Scene, frame input.InputEventTime, keyboard &input.Keyboard )
pub struct EntityAction {
	pub mut:
	parent_entity Entity
	max_uppdate_interval input.InputEventTime
	last_updated input.InputEventTime
	action_fn EntityActionFn = fn ( mut e &Entity, mut scene &Scene, frame input.InputEventTime, keyboard &input.Keyboard ){}
}
