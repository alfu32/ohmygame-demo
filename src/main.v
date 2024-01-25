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

fn main1() {
	mut kbd := omg.Keyboard{location: "/tmp/kbev/events"}
	println(kbd)
	dump(kbd)
	assert kbd.file.fd == 0
	assert kbd.file.is_opened == false
	kbd.init()
	for {
		evs := kbd.dequeue_events()
		println(evs)
	}
	dump(kbd)
	assert kbd.file.fd != 0
	assert kbd.file.is_opened == true
	kbd.close()
	println(kbd)
	dump(kbd)
	assert kbd.file.fd != 0
	assert kbd.file.is_opened == false
}
fn main() {
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
