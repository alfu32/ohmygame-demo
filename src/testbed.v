module main
import ohmygame as omg

pub fn maint(){

	mut plane := omg.Shape{
		anchor: omg.Point{1,1,1},
	}
	f:="
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
	plane.set_figure(f,f,f)
	dump(plane)

	plane.rotate_figure()
	dump(plane)
}