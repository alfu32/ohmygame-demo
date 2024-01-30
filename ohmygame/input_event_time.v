module ohmygame


pub struct InputEventTime{
	seconds u64
	nanos u64
}
pub fn input_event_time_from_str(s string) InputEventTime {
	t := s.split(".")
	return InputEventTime {
		seconds: (t[0]).u64()
		nanos: (pad_end(t[1],9,'0')).u64()
	}
}
pub fn (a InputEventTime) + (b InputEventTime) InputEventTime {
	n:=(a.nanos)+(b.nanos)
	s:=(a.seconds)+(b.seconds)
	return InputEventTime{
		seconds: s
		nanos: n
	}
}
pub fn (a InputEventTime) - (b InputEventTime) InputEventTime {
	if a.nanos > b.nanos {
		n:=(a.nanos)-(b.nanos)
		s:=(a.seconds)-(b.seconds)
		return InputEventTime{
			seconds: s
			nanos: n
		}
	} else {
		n:=u64(1000000000)+(a.nanos)-(b.nanos)
		s:=(a.seconds)-(b.seconds) - 1
		return InputEventTime{
			seconds: s
			nanos: n
		}
	}
}
pub fn (a InputEventTime) <(b InputEventTime) bool {
	return a.seconds < b.seconds ||
	( a.seconds==b.seconds && a.nanos<b.nanos)
}
pub fn (a InputEventTime) ==(b InputEventTime) bool {
	return ( a.seconds==b.seconds && a.nanos==b.nanos)
}
pub fn (a InputEventTime) to_string() string{
	nanos:=pad_start(a.nanos.str(),9,"0").substr(0,9)
	return "${a.seconds}.${nanos}"
}
