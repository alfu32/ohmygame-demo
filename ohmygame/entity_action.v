module ohmygame


pub enum EntityType {
	friend
	foe
	background_picture
	background_interactive
}
pub type EntityActionFn = fn ( mut e &Entity, mut scene &Scene, frame InputEventTime, keyboard &Keyboard )
pub struct EntityAction {
	pub mut:
	parent_entity Entity
	max_uppdate_interval InputEventTime
	last_updated InputEventTime
	action_fn EntityActionFn = fn ( mut e &Entity, mut scene &Scene, frame InputEventTime, keyboard &Keyboard ){}
}
