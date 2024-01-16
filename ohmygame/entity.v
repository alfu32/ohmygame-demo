module ohmygame

import term.ui as tui

pub const colors = [
	tui.Color{33, 150, 243},
	tui.Color{0, 150, 136},
	tui.Color{205, 220, 57},
	tui.Color{255, 152, 0},
	tui.Color{244, 67, 54},
	tui.Color{156, 39, 176},
]

pub struct Entity{
	shape Shape
	/// loss of energy inflicted on collision
	damage u32
	/// remaining energy
	energy u32
	/// actually antispeed (frames/unit), how many frames does it need to move one unit
	speed u32
}
