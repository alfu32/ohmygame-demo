module ohmygame


pub fn test_less_than(){

	a:=InputEventTime{
		seconds: 10
		nanos: 999999999
	}

	b:=InputEventTime{
		seconds: 20
		nanos: 2
	}

	dump(a)
	dump(b)
	assert a < b
	assert b>a
}
pub fn test_sum(){

	a:=InputEventTime{
		seconds: 150
		nanos: 3500000000
	}

	b:=InputEventTime{
		seconds: 180
		nanos: 4500000000
	}

	c:=a+b

	dump(a)
	dump(b)
	dump(c)
}
pub fn test_diff(){

	a:=InputEventTime{
		seconds: 50
		nanos: 3500000000
	}

	b:=InputEventTime{
		seconds: 80
		nanos: 4500000000
	}

	d:=b-a

	dump(b)
	dump(a)
	dump(d)
}
pub fn test_diff_with_carry_nanos(){

	a:=InputEventTime{
		seconds: 20
		nanos: 400000000
	}

	b:=InputEventTime{
		seconds: 31
		nanos: 399999999
	}
	c:=input_event_time_from_str("10.999999999")

	d:=b-a

	dump(b)
	dump(a)
	dump(d)
	dump(c)

	assert c == d
}
