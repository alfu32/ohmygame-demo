module main

import ohmygame as omg
import term
import time
import input
import rand

const millis = 1000000
fn main() {
	mut t := omg.Terminal{}
	// initializing keyboard device
	mut kbd := input.Keyboard{location: "/tmp/kbev/events"}
	// mut kbd := omg.Keyboard{location: "/dev/input/event20"}
	kbd.init()
	// init scenes
	mut intro := omg.scene_create(120,35)
	mut game := omg.scene_create(120,35)
	mut end_scene := omg.scene_create(120,35)
	intro.add_object(omg.create_splash_screen("
		WWWW           WWWW  EEEEEEEEE LLLL         CCCCCCCCC       OOOOOO     MMM          MMM EEEEEEEEE
		WWWW           WWWW  EEEEEEEEE LLLL        CCCCCCCCCCC    OOOOOOOOOO   MMMMM      MMMMM EEEEEEEEE
		WWWW           WWWW  EEE       LLLL       CCCC     CCCC  OOOO    OOOO  MMM MMMMMMMM MMM EEE
		WWWW           WWWW  EEEEEEE   LLLL       CCC           OOOOO    OOOOO MMM    MMM   MMM EEEEEEE
		WWWW     W     WWWW  EEE       LLLL       CCC           OOOOO    OOOOO MMM     M    MMM EEE
		 WWWW   WWW   WWWW   EEE       LLLL       CCCC     CCCC  OOOO    OOOO  MMM          MMM EEE
		  WWWW WWWWW WWWW    EEEEEEEEE LLLLLLLLL   CCCCCCCCCC     OOOOOOOOOO   MMM          MMM EEEEEEEEE
		    WWWWW WWWWW      EEEEEEEEE LLLLLLLLL    CCCCCCCC        OOOOOO     MMM          MMM EEEEEEEEE

	     PRESS 'q' TO CONTINUE
	"))
	mut ship :=omg.Entity{
		parent_scene: game
		instance_id: rand.uuid_v4()
		user: 'root'
		shape: omg.Shape{
			anchor: omg.Point{10,10,0}
		}
		actions: [
			omg.action_move_using_keys(input.input_event_time_from_str("0.0001"),[input.KeyCode.left,input.KeyCode.right,input.KeyCode.up,input.KeyCode.down])
			omg.action_self_distruct(input.input_event_time_from_str("0.0001"),input.KeyCode.o)
		]
		life: 100
		power: 1
	}
	ship.shape.set_figure(
		"
		----###
		   <# ###>
		  +++(====)#####\a
		   <# ###>
		----###
		",
		"
		0000000
		   0000000
		  000000000000000
		   0000000
		0000000
		",
		"
		1111111
		   1111111
		  11111111111111
		   1111111
		1111111
		"
	)
	game.add_object(ship)
	end_scene.add_object(omg.create_splash_screen("
		TTTTTTTTT  HHH   HHH EEEEEEEE      EEEEEEEE NNN    NN  DDDDDD
		   TTT     HHH   HHH EEE           EEE      NNNNN  NN  DDD   DD
		   TTT     HHHHHHHHH EEEEEE        EEEEEE   NNN NN NN  DDD    DD
		   TTT     HHH   HHH EEE           EEE      NNN  NNNN  DDD    DD
		   TTT     HHH   HHH EEE           EEE      NNN    NN  DDD   DD
		   TTT     HHH   HHH EEEEEEEE      EEEEEEEE NNN    NN  DDDDDD

		               press q to EXIT ...
	"))
	mut level := omg.level_create(145,35,
		[
			&intro,
			&game,
			&end_scene,
		]
	)
	mut running:=true
	//for !level.is_finished(&kbd){
	for mut scene in level.scenes {
		for running && !scene.is_finished() {
			frame := input.input_event_time_now()
			kbd.refresh_state()
			if kbd.any_is_pressed([input.KeyCode.esc]) {
				running = false
				println("exiting")
				break
			}
			scene.run_actions(frame,&kbd)
			scene.do_collisions()
			scene.remove_dead_entities()
			scene.update_canvas()
			t.clear()
			/// println(frame)
			scene.canvas.render_to_terminal(mut &t)
			// omg.print_debug("time.sleep(1000*1000*1)")
			/// time.sleep(100 * millis)
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
		frame:input.input_event_time_now()
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
