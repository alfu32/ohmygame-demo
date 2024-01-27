module main

import ohmygame as omg
import term.ui as tui
import time
import term

const millis = 1000000
pub fn fetch_keys() !string {
	cfg:= tui.Config{
		buffer_size :  256
		frame_rate  :  30
		use_x11     : false
	}
	mut vtx:=tui.init(cfg) as &tui.Context
	vtx.run()!
	return "abcd"
}

fn main() {
	mut kbd := omg.Keyboard{location: "/tmp/kbev/events"}
	kbd.init()
	//println(kbd)
	println("\nstarting\n")
	term.hide_cursor()
	for _ in 1 ..100000 {

		kbd=kbd.refresh_state()
		mut pressed:=[]i32{}
		for k,v in kbd.pressed {
			if v!=0 {
				pressed << k
			}
		}
		print("\r${pressed}                       ")
		if 1 in pressed {
			break
		}
		/// print("\r${kbd.pressed.keys()}")
		time.sleep(1000*1000*1)
	}
	term.show_cursor()
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
