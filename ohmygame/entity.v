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
			action_move_using_keys(input.input_event_time_from_str("0.001"),[input.KeyCode.a,input.KeyCode.d,input.KeyCode.w,input.KeyCode.s])
			action_self_distruct(input.input_event_time_from_str("0.001"),input.KeyCode.o)
		]
	}
	ent.shape.set_figure(figure,figure,figure)
	return ent
}
