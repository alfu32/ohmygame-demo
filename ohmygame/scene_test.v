module ohmygame

import term.ui as tui
import time
import term



@[heap]
struct Application{
	pub  mut:
	current tui.Event
	scene Scene
}

pub fn test_render(){
	mut canvas := drawing_context_2d_create(50,20," ")
	println("ohmygame.DrawingContext2D:${canvas}")
	mut scene:=Scene{
		objects:[]&Entity{}
		canvas:canvas
		frame: time.now()
	}
	println("ohmygame.Scene:${scene}")

	mut ship:= create_player_ship(
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
	println("ohmygame.Entity:${ship}")
	scene.objects << ship
	scene.update()

	println("ohmygame.Scene:${scene}")

	mut app:=Application{
		scene:scene
	}
	for i in 0..100 {
		time.sleep(.5)
	}
	//app.tui_ref.run()!

}

pub fn test_render_to_string(){
	mut canvas := drawing_context_2d_create(160,15," ")
	dump("ohmygame.DrawingContext2D:${canvas}")
	mut scene:=Scene{
		objects:[]&Entity{}
		canvas:canvas
		frame:time.now()
	}
	dump("ohmygame.Scene:${scene}")

	mut ship:= create_player_ship(
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
	dump("ohmygame.Entity:${ship}")
	scene.objects << ship
	dump("ohmygame.Scene:${scene}")
	for i in 1..100 {
		print(ansi_cls)
		ship.shape.anchor.x=ship.shape.anchor.x+1
		term.clear()
		scene.update()
		print(scene.render_to_string())
		flush_stdout()
		time.sleep(0.3)
	}
	scene.update()
	dump(scene.render_to_string())
	ship.shape.anchor.x=ship.shape.anchor.x+2
	dump(ship.shape)
	scene.update()
	dump(scene.render_to_string())
	ship.shape.anchor.x=ship.shape.anchor.x+2
	dump(ship.shape)
	scene.update()
	dump(scene.render_to_string())
	dump(scene)
}
