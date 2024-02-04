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
	mut canvas:= omg.drawing_context_2d_create(120,35," ")
	// init scenes
	mut intro := omg.scene_create()
	mut game := omg.scene_create()
	mut end_scene := omg.scene_create()
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
			omg.action_fn(
			input.input_event_time_from_str("0.0001"),
			fn [mut game]( mut e &omg.Entity, mut scene &omg.Scene, frame input.InputEventTime, keyboard &input.Keyboard ) {
				if keyboard.is_pressed(input.KeyCode.z) {
					mut bullet := omg.create_entity_rocket("====->",e)
					game.add_object(bullet)
				}
			})
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
			canvas.autoresize(kbd)
			if kbd.any_is_pressed([input.KeyCode.esc]) {
				running = false
				println("exiting")
				break
			}
			scene.run_actions(frame,&kbd)
			scene.do_collisions()
			scene.remove_dead_entities()
			scene.update_canvas(mut canvas)
			t.clear()
			/// println(frame)
			canvas.render_to_terminal(mut &t)
			// omg.print_debug("time.sleep(1000*1000*1)")
			/// time.sleep(100 * millis)
		}
	}
	test_keys(mut kbd)

	// deinit keyboard
	kbd.close()
	// dump(level)
	println("\n")
	mut evtypes:=map[u16]input.InputEvent{}
	for ev in kbd.events {
		evtypes[ev.typ]=ev
	}
	for k,e in evtypes {
		println("${k:10} : ${e}")
	}
}

fn test_keys(mut kbd &input.Keyboard) {
	mut running:=true
	for running {
		print('\x1b[2J')
		print('\x1b[H')
		flush_stdout()
		kbd.refresh_state()
		// print_debug("kbd.refresh_state()")
		mut evs :=map[input.KeyCode]input.InputEvent{}
		evts:=kbd.events
		// if kbd.any_is_pressed(['escape','key_256']) {
		// 	println("exiting")
		// 	running=false
		// 	break
		// }
		///for ev in evts {
		///	evs[omg.key_code_from_int(ev.code >> 8)] = ev
		///}
		// print("\r${evts}")
		for k,v in kbd.pressed {
			if v.value != 0{
				println("${k:30} : ${v.hex()}")
			}
		}
		// print("\r${evs.values().map(it.hex()).join("\n")}")
		flush_stdout()
		if kbd.any_is_pressed([input.KeyCode.esc]) {
			running = false
			println("exiting")
		}

		//level.render(mut t, kbd)
		// omg.print_debug("time.sleep(1000*1000*1)")
		time.sleep(100*millis)

		// t.flush()
	}
}
