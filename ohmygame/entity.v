module ohmygame

import rand
import input

@[heap]
pub struct Entity{
	pub mut:
		parent_scene Scene
		instance_id string//  = rand.uuid_v4()
		user string
		shape Shape
		actions []EntityAction
		life u64 = 100
		power u64 = 10
}


pub fn (mut e Entity)run_actions( frame input.InputEventTime, keyboard &input.Keyboard ){
	for mut a in e.actions {
		if a.max_uppdate_interval < frame - a.last_updated {
			a.action_fn(mut &e,mut &e.parent_scene,frame,keyboard)
			a.last_updated = frame
		}
	}
}

pub fn create_user_actionable_object(figure string) &Entity {
	mut ent := &Entity {
		instance_id: rand.uuid_v4()
		shape: Shape{
			anchor: Point{2,3,4}
		}
	}
	ent.shape.set_figure(figure,figure,figure)
	return ent
}

pub fn create_splash_screen(figure string) &Entity {
	mut ent := &Entity {
		instance_id: rand.uuid_v4()
		shape: Shape{
			anchor: Point{2,3,4}
		},
		actions: [
			EntityAction {
				parent_entity: Entity{}
				max_uppdate_interval: input.input_event_time_from_str("0.001")
				last_updated: input.input_event_time_now()
				action_fn: fn ( mut e &Entity, mut scene &Scene, frame input.InputEventTime, keyboard &input.Keyboard ) {
					if keyboard.is_pressed(input.KeyCode.space) {
						e.life=0
					}
					if keyboard.is_pressed(input.KeyCode.a) {
						e.shape.anchor.x -= 1
					}
					if keyboard.is_pressed(input.KeyCode.d) {
						e.shape.anchor.x += 1
					}
					if keyboard.is_pressed(input.KeyCode.w) {
						e.shape.anchor.y -= 1
					}
					if keyboard.is_pressed(input.KeyCode.s) {
						e.shape.anchor.y += 1
					}
				}
			}
		]
	}
	ent.shape.set_figure(figure,figure,figure)
	return ent
}
