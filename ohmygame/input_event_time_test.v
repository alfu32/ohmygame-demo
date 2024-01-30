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

	dump(a.to_string())
	dump(b.to_string())
	assert a < b
	assert b>a
}
pub fn test_sum(){

	a:=InputEventTime{
		seconds: 150
		nanos: 350000000
	}

	b:=InputEventTime{
		seconds: 180
		nanos: 450000000
	}

	c:=a+b

	dump(a.to_string())
	dump(b.to_string())
	dump(c.to_string())
	assert c == input_event_time_from_str('330.8')
}
pub fn test_diff(){

	a:=InputEventTime{
		seconds: 50
		nanos: 350000000
	}

	b:=InputEventTime{
		seconds: 80
		nanos: 450000000
	}

	d:=b-a

	dump(b.to_string())
	dump(a.to_string())
	dump(d.to_string())
	assert d == input_event_time_from_str('30.1')
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

	d:=b-a

	dump(b)
	dump(a)
	dump(d)

	assert d == input_event_time_from_str("10.999999999")
}
