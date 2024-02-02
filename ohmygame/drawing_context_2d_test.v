module ohmygame

fn test_drawing_context_2d_create(){
	vp:=drawing_context_2d_create(120,40," ")

	dump(vp)
}

fn test_drawing_context_2d_to_string(){
	mut vp:=drawing_context_2d_create(120,40," ")


	mut ship:= create_user_actionable_object(
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
	vp.print_shape(ship.shape)
	dump(vp.render_to_string())
}
