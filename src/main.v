module main



import term.ui as tui
import time
import ohmygame as omg

@[heap]
struct Application{
	pub  mut:
	current tui.Event
	scene omg.Scene
	buffer map[string]string
	keys string

	mut:
		tui_ref       &tui.Context = unsafe { nil }
		points    []omg.Point
		color     tui.Color = omg.color_codes[0]
		color_idx int
		cut_rate  f64 = 5
}

pub fn (mut app Application) frame(mut va Application) {
	app.tui_ref.clear()

	app.scene.next(app.keys)
	app.scene.update()
	app.scene.render(mut app.tui_ref)
	app.tui_ref.reset()
	app.tui_ref.flush()
}

pub fn (mut app Application) event(e &tui.Event, mut va Application) {

		app.current=e
		code := e.code.str()
		app.buffer["dbg"] = e.str()
		app.buffer["ts"] = time.now().str()

		if e.typ == .key_down {
			app.buffer[code]=code
			app.buffer["keys"]=""
		} else {
			app.buffer["code"]=code
		}
}

pub fn app_init() &Application{
	mut canvas:= omg.drawing_context_2d_create(144,45," ")
	println("ohmygame.DrawingContext2D:${canvas}")
	mut scene:=omg.Scene{
		objects:[]omg.Entity{}
		canvas:canvas
		frame:0
	}
	println("ohmygame.Scene:${scene}")

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
		omg.make_user_input_next_action("wasd"),
	)
	println("ohmygame.Entity:${ship}")
	scene.objects << ship
	scene.update()

	println("ohmygame.Scene:${scene}")

	mut app:=&Application{
		scene:scene
	}
	mut tui_ref := tui.init(
		user_data: &app
		frame_fn: app.frame
		event_fn: app.event
		hide_cursor: true
	)
	println("tui.Context:${tui_ref}")
	return app

}

fn main() {
	mut app := app_init()
	mut tui_ref := tui.init(
		user_data: app
		frame_fn: app.frame
		event_fn: app.event
		hide_cursor: true
	)
	app.tui_ref = tui_ref
	tui_ref.run()!
}