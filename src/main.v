module main

import ohmygame as omg


fn main() {

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
		omg.make_user_input_next_action(omg.string_to_keycodes("wasd")),
	)
	mut app := omg.app_init()
	app.add_object(ship)
	//// println(app)
	app.run() or {
		panic("encountered $err")
	}
}
