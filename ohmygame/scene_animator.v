module ohmygame

import term.ui as tui


pub fn char_to_keycode(code string) tui.KeyCode {
	kc := match code {
		'\0' { tui.KeyCode.null }
		'\t' { tui.KeyCode.tab }
		'\n' { tui.KeyCode.enter }
		' ' { tui.KeyCode.space }
		'backspace' { tui.KeyCode.backspace }
		'!' { tui.KeyCode.exclamation }
		'"' { tui.KeyCode.double_quote }
		'#' { tui.KeyCode.hashtag }
		'$' { tui.KeyCode.dollar }
		'%' { tui.KeyCode.percent }
		'&' { tui.KeyCode.ampersand }
		"'" { tui.KeyCode.single_quote }
		'(' { tui.KeyCode.left_paren }
		')' { tui.KeyCode.right_paren }
		'*' { tui.KeyCode.asterisk }
		'+' { tui.KeyCode.plus }
		',' { tui.KeyCode.comma }
		'-' { tui.KeyCode.minus }
		'.' { tui.KeyCode.period }
		'/' { tui.KeyCode.slash }
		'0' { tui.KeyCode._0 }
		'1' { tui.KeyCode._1 }
		'2' { tui.KeyCode._2 }
		'3' { tui.KeyCode._3 }
		'4' { tui.KeyCode._4 }
		'5' { tui.KeyCode._5 }
		'6' { tui.KeyCode._6 }
		'7' { tui.KeyCode._7 }
		'8' { tui.KeyCode._8 }
		'9' { tui.KeyCode._9 }
		':' { tui.KeyCode.colon }
		';' { tui.KeyCode.semicolon }
		'<' { tui.KeyCode.less_than }
		'=' { tui.KeyCode.equal }
		'>' { tui.KeyCode.greater_than }
		'?' { tui.KeyCode.question_mark }
		'@' { tui.KeyCode.at }
		'a' { tui.KeyCode.a }
		'b' { tui.KeyCode.b }
		'c' { tui.KeyCode.c }
		'd' { tui.KeyCode.d }
		'e' { tui.KeyCode.e }
		'f' { tui.KeyCode.f }
		'g' { tui.KeyCode.g }
		'h' { tui.KeyCode.h }
		'i' { tui.KeyCode.i }
		'j' { tui.KeyCode.j }
		'k' { tui.KeyCode.k }
		'l' { tui.KeyCode.l }
		'm' { tui.KeyCode.m }
		'n' { tui.KeyCode.n }
		'o' { tui.KeyCode.o }
		'p' { tui.KeyCode.p }
		'q' { tui.KeyCode.q }
		'r' { tui.KeyCode.r }
		's' { tui.KeyCode.s }
		't' { tui.KeyCode.t }
		'u' { tui.KeyCode.u }
		'v' { tui.KeyCode.v }
		'w' { tui.KeyCode.w }
		'x' { tui.KeyCode.x }
		'y' { tui.KeyCode.y }
		'z' { tui.KeyCode.z }
		'[' { tui.KeyCode.left_square_bracket }
		'\\' { tui.KeyCode.backslash }
		']' { tui.KeyCode.right_square_bracket }
		'^' { tui.KeyCode.caret }
		'_' { tui.KeyCode.underscore }
		'`' { tui.KeyCode.backtick }
		'{' { tui.KeyCode.left_curly_bracket }
		'|' { tui.KeyCode.vertical_bar }
		'}' { tui.KeyCode.right_curly_bracket }
		'~' { tui.KeyCode.tilde }
		'insert' { tui.KeyCode.insert }
		'delete' { tui.KeyCode.delete }
		'up' { tui.KeyCode.up }
		'down' { tui.KeyCode.down }
		'right' { tui.KeyCode.right }
		'left' { tui.KeyCode.left }
		'page_up' { tui.KeyCode.page_up }
		'page_down' { tui.KeyCode.page_down }
		'home' { tui.KeyCode.home }
		'end' { tui.KeyCode.end }
		'f1' { tui.KeyCode.f1 }
		'f2' { tui.KeyCode.f2 }
		'f3' { tui.KeyCode.f3 }
		'f4' { tui.KeyCode.f4 }
		'f5' { tui.KeyCode.f5 }
		'f6' { tui.KeyCode.f6 }
		'f7' { tui.KeyCode.f7 }
		'f8' { tui.KeyCode.f8 }
		'f9' { tui.KeyCode.f9 }
		'f10' { tui.KeyCode.f10 }
		'f11' { tui.KeyCode.f11 }
		'f12' { tui.KeyCode.f12 }
		'f13' { tui.KeyCode.f13 }
		'f14' { tui.KeyCode.f14 }
		'f15' { tui.KeyCode.f15 }
		'f16' { tui.KeyCode.f16 }
		'f17' { tui.KeyCode.f17 }
		'f18' { tui.KeyCode.f18 }
		'f19' { tui.KeyCode.f19 }
		'f20' { tui.KeyCode.f20 }
		'f21' { tui.KeyCode.f21 }
		'f22' { tui.KeyCode.f22 }
		'f23' { tui.KeyCode.f23 }
		'f24' { tui.KeyCode.f24 }
		else { tui.KeyCode.null }
	}
	return kc
}
pub fn string_to_keycodes(list string) []tui.KeyCode {
	return list.split(",").map(char_to_keycode)
}
pub fn keycode_to_char(e tui.Event) u8 {
		code := match e.code {
			.null { '\0' }
			.tab { '\t' }
			.enter { '\n' }
			.space { ' ' }
			.backspace { '0' }
			.exclamation { '!' }
			.double_quote { '"' }
			.hashtag { '#' }
			.dollar { '$' }
			.percent { '%' }
			.ampersand { '&' }
			.single_quote { "'" }
			.left_paren { '(' }
			.right_paren { ')' }
			.asterisk { '*' }
			.plus { '+' }
			.comma { ',' }
			.minus { '-' }
			.period { '.' }
			.slash { '/' }
			._0 { '0' }
			._1 { '1' }
			._2 { '2' }
			._3 { '3' }
			._4 { '4' }
			._5 { '5' }
			._6 { '6' }
			._7 { '7' }
			._8 { '8' }
			._9 { '9' }
			.colon { ':' }
			.semicolon { ';' }
			.less_than { '<' }
			.equal { '=' }
			.greater_than { '>' }
			.question_mark { '?' }
			.at { '@' }
			.a { 'a' }
			.b { 'b' }
			.c { 'c' }
			.d { 'd' }
			.e { 'e' }
			.f { 'f' }
			.g { 'g' }
			.h { 'h' }
			.i { 'i' }
			.j { 'j' }
			.k { 'k' }
			.l { 'l' }
			.m { 'm' }
			.n { 'n' }
			.o { 'o' }
			.p { 'p' }
			.q { 'q' }
			.r { 'r' }
			.s { 's' }
			.t { 't' }
			.u { 'u' }
			.v { 'v' }
			.w { 'w' }
			.x { 'x' }
			.y { 'y' }
			.z { 'z' }
			.left_square_bracket { '[' }
			.backslash { '\\' }
			.right_square_bracket { ']' }
			.caret { '_' }
			.underscore { '_' }
			.backtick { '`' }
			.left_curly_bracket { '{' }
			.vertical_bar { '|' }
			.right_curly_bracket { '}' }
			.tilde { '~' }
			.insert { '0' }
			.delete { '0' }
			.up { '0' }
			.down { '0' }
			.right { '0' }
			.left { '0' }
			.page_up { '0' }
			.page_down { '0' }
			.home { '0' }
			.end { '0' }
			.f1 { '0' }
			.f2 { '0' }
			.f3 { '0' }
			.f4 { '0' }
			.f5 { '0' }
			.f6 { '0' }
			.f7 { '0' }
			.f8 { '0' }
			.f9 { '0' }
			.f10 { '0' }
			.f11 { '0' }
			.f12 { '0' }
			.f13 { '0' }
			.f14 { '0' }
			.f15 { '0' }
			.f16 { '0' }
			.f17 { '0' }
			.f18 { '0' }
			.f19 { '0' }
			.f20 { '0' }
			.f21 { '0' }
			.f22 { '0' }
			.f23 { '0' }
			.f24 { '0' }
			else { '0' }
		}
		return code[0]
	}

@[heap]
struct SceneAnimator{
	pub  mut:
	current tui.Event
	scene Scene
	buffer map[string]string
	keys []tui.KeyCode
	current_frame u64
	events []tui.Event

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
	for e in sa.events {

		match e.typ {
			.key_down {
				sa.keys=[e.code]
			}
			.resized {
				sa.scene.canvas.resize(e.width,e.height)
			}
			else {
			}
		}
	}
	sa.events=[]
	sa.current_frame+=1
}

pub fn event(e &tui.Event, mut sa SceneAnimator) {
	match e.typ {
		.key_down {
			sa.keys=[e.code]
		}
		.resized {
			sa.events << e
		}
		else {
			// sa.buffer["code"]=code
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

	// tui_ref.paused = true
	// tui_ref.enable_su = true
	// tui_ref.enable_rgb = true

	app.set_tui_ref(tui_ref)
	return app
}
