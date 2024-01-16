module main



import term.ui as tui
import time
import ohmygame as omg

@[heap]
struct Application{
	pub  mut:
	current tui.Event
	buffer map[string]string

	mut:
		tui_ref       &tui.Context = unsafe { nil }
		points    []omg.Point
		color     tui.Color = omg.colors[0]
		color_idx int
		cut_rate  f64 = 5
}

fn (mut app Application) frame(mut va Application) {
	app.tui_ref.clear()

	app.tui_ref.bold()
	app.tui_ref.draw_text(6, 2, 'V term.input: ${va.buffer}')
	app.tui_ref.horizontal_separator(3)
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

fn main() {
	mut app := &Application{}
	mut tui_ref := tui.init(
		user_data: app
		frame_fn: app.frame
		event_fn: app.event
		hide_cursor: true
	)
	app.tui_ref = tui_ref
	tui_ref.run()!
}