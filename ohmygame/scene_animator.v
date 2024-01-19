module ohmygame

import time
import term.ui as tui
import math



[heap]
struct SceneAnimator{
	pub  mut:
	current tui.Event
	scene Scene
	buffer map[string]string
	keys string
	current_frame u64

	mut:
	tui_ref       &tui.Context = unsafe { nil }
	points    []Point
	color     tui.Color = color_codes[0]
	color_idx int
	cut_rate  f64 = 5
}

pub fn (mut sa SceneAnimator) set_tui_ref(tui_ref &tui.Context) {
	unsafe {
		sa.tui_ref=tui_ref
	}
}

pub fn (mut sa SceneAnimator) add_object(e &Entity) {
	sa.scene.objects << e
}
pub fn (mut sa SceneAnimator) run() ! {
	sa.tui_ref.run()!
}

pub fn frame(mut sa SceneAnimator) {
	sa.tui_ref.clear()

	sa.scene.next(sa.keys)
	sa.scene.animate()
	sa.scene.render(mut sa.tui_ref)
	sa.tui_ref.draw_text(0,0,"FRAME ${sa.current_frame}")
	sa.tui_ref.reset()
	sa.tui_ref.flush()
	sa.current_frame+=1
}

pub fn event(e &tui.Event, mut sa SceneAnimator) {

	sa.current=e
	code := e.code.str()
	sa.buffer["dbg"] = e.str()
	sa.buffer["ts"] = time.now().str()
	match e.typ {
		.key_down {
			sa.buffer[code]=code
			sa.buffer["keys"]=""
		}
		.resized {
			sa.scene.canvas.resize(e.width,e.height)
		}
		else {
			sa.buffer["code"]=code
		}
	}
}

pub fn app_init() &SceneAnimator{
	mut app:=&SceneAnimator{
		scene:Scene{
			objects:[]Entity{}
			canvas:drawing_context_2d_create(144,45," ")
			frame:0
		},
	}
	mut tui_ref := tui.init(
		user_data: app
		frame_fn: frame
		event_fn: event
		hide_cursor: true
	)
	app.set_tui_ref(tui_ref)
	return app
}
