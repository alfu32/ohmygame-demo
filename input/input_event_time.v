module input

import time
import utils

type Seconds = i64
type Nanos = i64
fn convert_seconds(s string) Seconds {
	return s.i64()
}
fn convert_nanos(s string) Seconds {
	return s.i64()
}
pub struct InputEventTime{
	pub mut:
	seconds Seconds
	nanos Nanos
}
pub fn input_event_time_from_str(s string) InputEventTime {
	t := s.split(".")
	return InputEventTime {
		// seconds: (t[0]).u32()
		// nanos: (utils.pad_end(t[1],9,'0')).u32()
		seconds: convert_seconds(t[0])
		nanos: convert_nanos(utils.pad_end(t[1],9,'0'))
	}
}
pub fn input_event_time_now() InputEventTime {
	t := time.now()
	return InputEventTime {
		// seconds: t.unix.str().u32()
		// nanos: t.nanosecond.str().u32()
		seconds: convert_seconds(t.unix.str())
		nanos: convert_nanos(t.nanosecond.str())
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
		n:=convert_nanos("1000000000")+(a.nanos)-(b.nanos)
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
	nanos:=utils.pad_start(a.nanos.str(),9,"0").substr(0,9)
	return "${a.seconds}.${nanos}"
}
pub fn (a InputEventTime) hex() string{
	// nanos:=utils.pad_start(a.nanos.str(),9,"0").substr(0,9)
	return "${a.seconds:08x}.${a.nanos:08x}"
}
