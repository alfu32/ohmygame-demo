module main

import ohmygame as omg
import term
import time

const millis = 1000000

fn main() {
	mut t := omg.Terminal{}
	// initializing keyboard device
	mut kbd := omg.Keyboard{location: "/tmp/kbev/events"}
	kbd.init()
	// init scenes
	mut intro := omg.Scene{}
	mut game := omg.Scene{}
	mut end_scene := omg.Scene{}
	intro.add_object(omg.create_splash_screen("
		WELCOME TO THE DEMO
		intro screen

		press enter to continue ...
	"))
	game.add_object(omg.create_splash_screen("
		WELCOME TO THE DEMO
		game screen

		press enter to continue ...
	"))
	end_scene.add_object(omg.create_splash_screen("
		WELCOME TO THE DEMO
		finish screen

		press enter to continue ...
	"))
	mut level := omg.level_create(145,40,
		[
			&intro,
			&game,
			&end_scene,
		]
	)
	dump(level)

	for level.is_finished(&kbd){
		kbd.refresh_state()
		if kbd.any_is_pressed(['escape']) {
			break
		}

		level.current_scene.run_actions(omg.input_event_time_now(),kbd)
		level.current_scene.do_collisions()
		/// print("\r${kbd.pressed.keys()}")
		t.clear()
		level.current_scene.render_to_terminal(mut &t)
		time.sleep(1000*1000*1)
		level.current_scene.remove_dead_entities()
	}

	// deinit keyboard
	kbd.close()
}
fn main0() {
	mut canvas := omg.drawing_context_2d_create(160,15," ")
	mut scene:=omg.Scene{
		objects:[]&omg.Entity{}
		canvas:canvas
		frame:omg.input_event_time_now()
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
