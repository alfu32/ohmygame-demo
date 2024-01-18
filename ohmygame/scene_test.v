module ohmygame

import term.ui as tui
import time

@[heap]
struct Application{
	pub  mut:
	current tui.Event
	scene Scene
	buffer map[string]string

	mut:
		tui_ref       &tui.Context = unsafe { nil }
		points    []Point
		color     tui.Color = color_codes[0]
		color_idx int
		cut_rate  f64 = 5
}
fn (mut app Application) frame(mut va Application) {
	app.tui_ref.clear()

	app.scene.update()
	app.scene.render(mut app.tui_ref)
	app.tui_ref.reset()
	app.tui_ref.flush()
}

fn (mut app Application) event(e &tui.Event, mut va Application) {

		app.current=e
		code := e.code.str()
		app.buffer["dbg"] = e.str()
		app.buffer["ts"] = time.now().str()

		if e.typ == .key_down {
			app.buffer[code]=code
		} else {
			app.buffer["code"]=code
		}
}

pub fn test_render(){
	mut canvas:DrawingContext2D = drawing_context_2d_create(50,20," ")
	println("ohmygame.DrawingContext2D:${canvas}")
	mut scene:=Scene{
		objects:[]Entity{}
		canvas:canvas
		frame:0
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
		make_user_input_next_action("wasd"),
	)
	println("ohmygame.Entity:${ship}")
	scene.objects << ship
	scene.update()

	println("ohmygame.Scene:${scene}")

	mut app:=Application{
		scene:scene
	}
	mut tui_ref := tui.init(
		user_data: &app
		frame_fn: app.frame
		event_fn: app.event
		hide_cursor: true
	)
	println("tui.Context:${tui_ref}")
	for i in 0..100 {
		time.sleep(.5)
		tui_ref.clear()
		canvas.
	}
	//app.tui_ref.run()!

}