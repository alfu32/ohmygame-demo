module ohmygame

import utils

fn test_create_shape(){
	mut plane := Shape{
		anchor: Point{1,1,1},
	}
	plane.set_figure("
		      *
		      #
		:     ##
		##   :###
		###::#####:::>
		##   :###
		:     ##
		      #
		      *
	    ","
		      3
		      3
		3     33
		33   3333
		33322333332221
		33   3333
		3     33
		      3
		      3
	    ","
		      *
		      #
		:     ##
		##   :###
		###::#####:::>
		##   :###
		:     ##
		      #
		      *
	    ")
	plane_box := plane.get_bounding_rectangle()
	dump(plane)
	dump(plane_box)

	assert plane_box.size.x == 14, "wrong shape size.x test"
	assert plane_box.size.y == 9,  "wrong shape size.y test"

}
fn test_rotate_buffer(){
	mut figure := utils.trim_indent(normalized_figure("
        #+-----+
        +test**|
        |ROTATE|
        +------+
	"),[u8(32)])

	dump("\n"+utils.buffer_to_string(figure))
	for _ in 0..4{
		figure=buffer_rotate2d_clockwise(figure)
		dump("\n"+utils.buffer_to_string(figure))
	}
}

fn test_cycle_buffer_horizontally(){
	mut figure := utils.trim_indent(normalized_figure("
        #.....+
        ##...++
        ###.+++
        ####+++
	"),[u8(32)])

	dump("\n"+utils.buffer_to_string(figure))
	for _ in 0..7{
		figure=buffer_shift_circular_horizontally(figure)
		dump("\n"+utils.buffer_to_string(figure))
	}
}
