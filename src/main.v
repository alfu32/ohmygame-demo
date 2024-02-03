module main

import ohmygame as omg
import term
import time

const millis = 1000000
fn main() {
	mut t := omg.Terminal{}
	// initializing keyboard device
	mut kbd := omg.Keyboard{location: "/tmp/kbev/events"}
	// mut kbd := omg.Keyboard{location: "/dev/input/event20"}
	kbd.init()
	// init scenes
	mut intro := omg.scene_create(120,40)
	mut game := omg.scene_create(120,40)
	mut end_scene := omg.scene_create(120,40)
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
	mut running:=true
	//for !level.is_finished(&kbd){
	for running {
		kbd.refresh_state()
		if kbd.any_is_pressed([omg.KeyCode.esc]) {
			running = false
			println("exiting")
		}
		if level.is_finished() {
			running = false
		} else {
			level.render(mut t, kbd)
			t.flush()
			// omg.print_debug("time.sleep(1000*1000*1)")
			time.sleep(100*millis)
		}
	}

	// deinit keyboard
	kbd.close()
	// dump(level)
	println("\n")
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
		println(scene.canvas.render_to_string())
		// flush_stdout()
		time.sleep(1*millis)
	}
}
