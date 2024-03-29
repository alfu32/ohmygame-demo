module ohmygame

import term.ui as tui
import rand

pub const color_codes = [
	tui.Color{0, 0, 0},
	tui.Color{0, 150, 136},
	tui.Color{33, 150, 243},
	tui.Color{205, 220, 57},
	tui.Color{255, 152, 0},
	tui.Color{244, 67, 54},
	tui.Color{156, 39, 176},
	tui.Color{225, 225, 225},
]
pub type EntityActionFn = fn(mut context Scene,mut e Entity, mut self EntityAction,keys string) EntityAction
pub type EntityFn = fn(mut context Scene,mut e Entity, keys string) Entity

pub struct EntityAction {
	name string
	mut:
	energy u64
	last_frame u64
	reaction_time u64
	next_frame EntityActionFn = fn(mut context Scene,mut e Entity, mut self EntityAction,keys string) EntityAction {return self}
}
pub fn (mut ea EntityAction) next(mut context Scene,mut e Entity,keys string){
	if context.frame-ea.last_frame > ea.reaction_time {
		ea.last_frame=context.frame
		ea.next_frame(mut context, mut e,mut ea,keys)
	}
}
pub struct Entity{
	pub mut:
	instance_id string//  = rand.uuid_v4()
	type_name string
	shape Shape
	/// loss of energy inflicted on collision
	damage u32
	/// remaining energy
	energy u32
	last_frame u64
	reaction_time u64
	actions map[string]EntityAction
	/// next entity state
	next_frame EntityFn = fn(mut context Scene,mut e Entity,keys string) Entity { return e}
}
pub fn (mut e Entity) next(mut context Scene, keys string){
	if context.frame-e.last_frame > e.reaction_time {
		e.last_frame=context.frame

		e.next_frame(mut context, mut e,keys)
	}
	for _,mut action in e.actions {
		action.next(mut context,mut e,keys)
	}
}



// factory makes it move like Jagger
pub fn make_user_input_next_action(keyscombo string) EntityFn {
	return fn[keyscombo](mut context Scene,mut e Entity,keys string) Entity {
		kbytes:=keys.bytes()
		if kbytes.contains(keyscombo[0]) {
			e.shape.anchor.y-=1
		}
		if kbytes.contains(keyscombo[1]) {
			e.shape.anchor.x-=1
		}
		if kbytes.contains(keyscombo[2]) {
			e.shape.anchor.y-=1
		}
		if kbytes.contains(keyscombo[3]) {
			e.shape.anchor.x+=1
		}
		e.shape.background=buffer_shift_circular_horizontally(e.shape.background)
		return e
	}
}


pub fn create_player_ship(figure string,next_frame EntityFn) Entity {
	mut ent := Entity {
		instance_id: rand.uuid_v4()
		shape: Shape{
			anchor: Point{2,3,4}
		}
	}
	ent.shape.set_figure(figure,figure,figure)
	ent.next_frame=next_frame
	return ent
}
