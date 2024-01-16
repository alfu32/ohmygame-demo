module main
import ohmygame as omg

pub fn maint(){

	plane := omg.Shape{
		anchor: omg.Point{1,1,1},
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

	dump(plane.rotate_figure())
}