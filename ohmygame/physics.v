module ohmygame

import math

pub struct Derivative {
	pub mut:
	vector_diff Point
	time_diff InputEventTime
}

pub fn derivative_of(v0 Point,v1 Point,t0 InputEventTime,t1 InputEventTime) Derivative {
	mut v00 :=v0.copy()
	mut v10 := v1.copy()
	v10.amplify(-1)
	return  Derivative{
		vector_diff: v10.add(v00)
		time_diff: t1-t0
	}
}

pub fn (d Derivative) magnitude() f64 {
	m:=d.time_diff.seconds
	return math.sqrt(d.vector_diff.len_squared() /m/m )
}
