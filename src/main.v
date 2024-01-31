module main

import ohmygame as omg
import time
import term

const millis = 1000000

fn main() {
	// initializing keyboard device
	mut kbd := omg.Keyboard{location: "/tmp/kbev/events"}
	kbd.init()
	// init scenes
	mut intro := omg.Scene{}
	mut game := omg.Scene{}
	mut end_scene := omg.Scene{}
	mut scenes :=[]omg.Scene{
		intro,
		game,
		end_scene,
	}
	mut current_scene_index:=0
	mut current_scene := scenes[current_scene_index]
	for {
		kbd.refresh_state()
		pressed:= kbd.get_pressed_keys()
		print("\r${pressed}                       ")
		if kbd.any_is_pressed(['escape']) {
			break
		}
		/// print("\r${kbd.pressed.keys()}")
		time.sleep(1000*1000*1)
		if scenes[current_scene_index].is_finished() {
			current_scene_index+=1
			current_scene = scenes[current_scene_index]
		}
		if &current_scene == voidptr {
			break
		}
	}

	// deinit keyboard
	kbd.close()
}
fn main0() {
	mut canvas := omg.drawing_context_2d_create(160,15," ")
	mut scene:=omg.Scene{
		objects:[]&omg.Entity{}
		canvas:canvas
		frame:time.now()
	}

	mut ship:= omg.create_user_actionable_object(
		"
		      *
		      #
		:     ##
		##   :###
		###::#####:::>
		##   :###
		:     ##
		      #
		      *
		",
	)
	scene.objects << ship
	for _ in 1..1000 {
		// term.erase_display("3")
		term.set_cursor_position(x:0,y:0)
		ship.shape.anchor.x=ship.shape.anchor.x+1
		if ship.shape.anchor.x > 149 {
			ship.shape.anchor.x=-10
		}
		scene.update_canvas()
		println(scene.render_to_string())
		// flush_stdout()
		time.sleep(1*millis)
	}
}
