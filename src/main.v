module main



import term.ui as tui
import time
import ohmygame as omg
import math

@[heap]
struct Application{
	pub  mut:
	current tui.Event
	scene omg.Scene
	buffer map[string]string
	keys string
	current_frame u64

	mut:
		tui_ref       &tui.Context = unsafe { nil }
		points    []omg.Point
		color     tui.Color = omg.color_codes[0]
		color_idx int
		cut_rate  f64 = 5
}

pub fn frame(mut app Application) {
	app.tui_ref.clear()

	app.scene.next(app.keys)
	h:=app.scene.canvas.window.size.y - 11
	d:=u64(5)
	app.scene.objects[0].shape.anchor.y=int(2 + h/2 + math.sin(f64((app.current_frame)%(180*d))/math.pi/f64(d))*h/2)
	app.scene.update()
	app.scene.render(mut app.tui_ref)
	app.tui_ref.draw_text(0,0,"FRAME ${app.current_frame}")
	app.tui_ref.reset()
	app.tui_ref.flush()
	app.current_frame+=1
}

pub fn event(e &tui.Event, mut app Application) {

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
	//// mut tui_ref := tui.init(
	//// 	user_data: &app
	//// 	frame_fn: fn(app Application){app.frame(mut app)}
	//// 	event_fn: fn(evt &tui.Event,app Application){app.event(evt,mut app)}
	//// 	hide_cursor: true
	//// )
	//// println("tui.Context:${tui_ref}")
	return app

}

fn main() {
	mut app := app_init()
	mut tui_ref := tui.init(
		user_data: app
		frame_fn: frame
		event_fn: event
		hide_cursor: true
	)
	app.tui_ref = tui_ref
	app.tui_ref.run()!
}