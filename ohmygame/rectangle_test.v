module ohmygame

fn test_create_rectangle(){
	a:= Rectangle{
		anchor: ohmygame.Point{1,1,1}
		size: ohmygame.Point{5,5,2}
	}
	dump(a)
}
fn test_corner(){
	a:= Rectangle{
		anchor: ohmygame.Point{1,2,3}
		size: ohmygame.Point{4,5,6}
	}
	assert a.corner().x == 5 , "failed corner x"
	assert a.corner().y == 7 , "failed corner y"
	assert a.corner().z == 9 , "failed corner z"
	dump(a)
	dump(a.corner())
}
fn test_corners(){
	a:= Rectangle{
		anchor: ohmygame.Point{1,2,3}
		size: ohmygame.Point{4,5,6}
	}
	for corner in a.corners() {
		dump(corner)
	}

	assert (a.corners().len == 8) , "doesnt have 8 corners"
	
	dump(a)
	dump(a.corners())
}
fn test_add(){
	a:= Rectangle{
		anchor: ohmygame.Point{1,2,3}
		size: ohmygame.Point{6,5,4}
	}
	dump(a)
	dump(a.corner())
	b:= Rectangle{
		anchor: ohmygame.Point{6,5,4}
		size: ohmygame.Point{1,2,3}
	}
	dump(b)
	dump(b.corner())
	c:=a.merge(b)
	dump(c)
	dump(c.corner())
}
fn test_contains_point(){
	a:= Rectangle{
		anchor: ohmygame.Point{1,2,3}
		size: ohmygame.Point{4,5,6}
	}
	for corner in a.corners() {
		dump(corner)
	}

	assert !a.contains_point(x:1,y:1,z:1) , "contains 1,1,1"
	assert a.contains_point(x:1,y:2,z:3) , "doesnt contain anchor"
	assert a.contains_point(x:5,y:7,z:9) , "doesnt contain corner"
	assert a.contains_point(x:4,y:4,z:4) , "doesnt contain corner"
	assert !a.contains_point(x:8,y:8,z:8) , "contains 8,8,8"
	
}
fn test_intersects(){
	a:= Rectangle{
		anchor: ohmygame.Point{1,2,3}
		size: ohmygame.Point{6,5,4}
	}
	dump(a)
	b:= Rectangle{
		anchor: ohmygame.Point{6,5,4}
		size: ohmygame.Point{1,2,3}
	}
	dump(b)
	c:=a.intersects(b)
	dump(c)
	assert c, "${a} does not intersect ${b}"
}