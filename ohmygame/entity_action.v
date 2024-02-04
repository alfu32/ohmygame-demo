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

pub fn action_move_using_keys(max_uppdate_interval input.InputEventTime,keys []input.KeyCode) EntityAction {
	return EntityAction {
		parent_entity: Entity{}
		max_uppdate_interval: max_uppdate_interval
		last_updated: input.input_event_time_now()
		action_fn: fn [keys] ( mut e &Entity, mut scene &Scene, frame input.InputEventTime, keyboard &input.Keyboard ) {
			if keyboard.is_pressed(keys[0]) {
				e.shape.anchor.x -= 1
			}
			if keyboard.is_pressed(keys[1]) {
				e.shape.anchor.x += 1
			}
			if keyboard.is_pressed(keys[2]) {
				e.shape.anchor.y -= 1
			}
			if keyboard.is_pressed(keys[3]) {
				e.shape.anchor.y += 1
			}
		}
	}
}
pub fn action_self_distruct(max_uppdate_interval input.InputEventTime,key input.KeyCode) EntityAction {
	return EntityAction {
		parent_entity: Entity{}
		max_uppdate_interval: max_uppdate_interval
		last_updated: input.input_event_time_now()
		action_fn: fn [key] ( mut e &Entity, mut scene &Scene, frame input.InputEventTime, keyboard &input.Keyboard ) {
			if keyboard.is_pressed(key) {
				e.life = 0
			}
		}
	}
}
