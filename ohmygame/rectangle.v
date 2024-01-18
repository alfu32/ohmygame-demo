module ohmygame

import math

pub struct Rectangle{
	pub mut:
	anchor Point
	size Point
}

pub fn (ra Rectangle) corner() Point{
	return Point{
		x:ra.anchor.x+ra.size.x
		y:ra.anchor.y+ra.size.y
		z:ra.anchor.z+ra.size.z
	}
}
pub fn (ra Rectangle) corners() []Point{
	mut corners:=[]Point{}
	a:=ra.anchor
	corner:=ra.corner()
	corners << ra.anchor.copy()                  //a0
	corners << Point{a.x,corner.y,a.z}           //b0
	corners << Point{corner.x,corner.y,a.z}      //c0
	corners << Point{corner.x,a.y,a.z}           //d0
	corners << Point{a.x,a.y,corner.z}           //a1
	corners << Point{a.x,corner.y,corner.z}      //b1
	corners << Point{corner.x,corner.y,corner.z} //c1
	corners << Point{corner.x,a.y,corner.z}      //d1
	return corners
}
pub fn (t Rectangle) merge(other Rectangle) Rectangle{
	self_corner := t.corner()
	other_corner := other.corner()
	mut result_anchor:=Point{
		x:math.min(t.anchor.x,other.anchor.x)
		y:math.min(t.anchor.y,other.anchor.y)
		z:math.min(t.anchor.z,other.anchor.z)
	}
	mut result_corner:=Point{
		x:math.max(self_corner.x,other_corner.x)
		y:math.max(self_corner.y,other_corner.y)
		z:math.max(self_corner.z,other_corner.z)
	}

	return Rectangle{
		anchor: result_anchor
		size:result_corner.add(result_anchor.amplify(-1))
	}
}

pub fn (ra Rectangle) contains_point(p Point) bool{
	c:=ra.corner()
	return p.x>=ra.anchor.x && p.x<=c.x && p.y>=ra.anchor.y && p.y<=c.y && p.z>=ra.anchor.z && p.z<=c.z
}
pub fn (ra Rectangle) intersects(rb Rectangle) bool{
	corners_a :=ra.corners()
	corners_b :=rb.corners()
	ainb := corners_a.filter(fn[rb](corner Point) bool {return rb.contains_point(corner)}).len
	bina := corners_b.filter(fn[ra](corner Point) bool {return ra.contains_point(corner)}).len
	return ainb+bina > 0
}

pub fn (sh Rectangle) str() string{
	return " { type: Rectangle, anchor: ${sh.anchor.str()}, size: ${sh.size.str()} }"
} 