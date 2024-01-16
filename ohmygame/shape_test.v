module ohmygame

fn test_create_shape(){
	plane := Shape{
		anchor: Point{1,1,1},
		figure:"
		      *
		      #
		:     ##
		##   :###
		###::#####:::>
		##   :###
		:     ##
		      #
		      *
		"
	}
	plane_box := plane.get_bounding_rectangle()

	assert plane_box.size.x == 14, "wrong shape size.x test"
	assert plane_box.size.y == 9,  "wrong shape size.y test"

	dump(plane)
	dump(plane_box)
}
fn test_rotate_shape(){
	mut plane := Shape{
		anchor: Point{1,1,1},
		figure:"
		      *
		      #
		:     ##
		##   :###
		###::#####:::>
		##   :###
		:     ##
		      #
		      *
		"
	}
	dump(plane)
	dump(plane.get_bounding_rectangle())
	plane.rotate_figure()
	dump(plane)
	dump(plane.get_bounding_rectangle())
	plane.rotate_figure()
	dump(plane)
	dump(plane.get_bounding_rectangle())
	plane.rotate_figure()
	dump(plane)
	dump(plane.get_bounding_rectangle())
	plane.rotate_figure()
	dump(plane)
	dump(plane.get_bounding_rectangle())
}