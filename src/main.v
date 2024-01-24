module main

import ohmygame as omg
import time
import term

const millis = 1000000
fn main() {
	mut canvas := omg.drawing_context_2d_create(160,15," ")
	mut scene:=omg.Scene{
		objects:[]&omg.Entity{}
		canvas:canvas
		frame:0
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
		omg.make_user_input_next_action(omg.string_to_keycodes("w,a,s,d")),
	)
	scene.objects << ship
	for _ in 1..1000 {
		// term.erase_display("3")
		term.set_cursor_position(x:0,y:0)
		ship.shape.anchor.x=ship.shape.anchor.x+1
		if ship.shape.anchor.x > 149 {
			ship.shape.anchor.x=-10
		}
		scene.animate()
		println(scene.render_to_string())
		// flush_stdout()
		time.sleep(1*millis)
	}
}
