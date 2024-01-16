module ohmygame


pub struct Point {
	pub mut:
	x int
	y int
	z int
}

pub fn (mut p Point) add(b Point) Point {
	p.x+=b.x
	p.y+=b.y
	p.z*=b.z
	return p
}


pub fn (mut p Point) scale(b Point) Point {
	p.x*=b.x
	p.y*=b.y
	p.z*=b.z
	return p
}
pub fn (mut p Point) amplify(b int) Point {
	p.x*=b
	p.y*=b
	p.z*=b
	return p
}
pub fn (ra Point) copy() Point{
	return Point{
		x:ra.x
		y:ra.y
		z:ra.z
	}
}
pub fn (ra Point) str() string{
	return "ohmygame.Point{x:${ra.x},y:${ra.y},z:${ra.z}}"
}