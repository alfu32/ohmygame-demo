module main

import ohmygame as omg
import time
import term

const millis = 1000000

fn main() {
	mut kbd := omg.Keyboard{location: "/tmp/kbev/events"}
	kbd.init()
	//println(kbd)
	println("\nstarting\n")
	for _ in 1 ..100000 {
		kbd.refresh_state()
		pressed:= kbd.get_pressed_keys()
		print("\r${pressed}                       ")
		if kbd.any_is_pressed(['escape']) {
			break
		}
		/// print("\r${kbd.pressed.keys()}")
		time.sleep(1000*1000*1)
	}
	println("\ndone\n")
	println(kbd)
	kbd.close()
}
fn main0() {
	mut canvas := omg.drawing_context_2d_create(160,15," ")
	mut scene:=omg.Scene{
		objects:[]&omg.Entity{}
		canvas:canvas
		frame:time.now()
	}

	mut ship:= omg.create_player_ship(
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
		scene.update()
		println(scene.render_to_string())
		// flush_stdout()
		time.sleep(1*millis)
	}
}
