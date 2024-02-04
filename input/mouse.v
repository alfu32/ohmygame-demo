module input

import term.termios
import os

pub struct MouseInputEvent{
	pub mut:
	event_timestamp InputEventTime
	typ u16
	code u16
	x u16
	y u16
}
pub fn (ie MouseInputEvent) str() string {
	return "MouseInputEvent{timestamp:${ie.event_timestamp.hex()},typ:${ie.typ},code:${ie.code},x:${ie.y},x:${ie.y}}"
}
pub fn (ie MouseInputEvent) hex() string {
	return "MouseInputEvent{T ${ie.event_timestamp.hex()} TY ${ie.typ:04x} C ${ie.code:04X} V ${ie.x:04x},${ie.y:04x}}"
}

pub struct Mouse{
	pub:
	location string
	pub mut:
	file os.File
	events []InputEvent
	pressed map[KeyCode]InputEvent
	stdin os.File
	original_term termios.Termios
	silent_term termios.Termios
}
pub fn (mut mouse Mouse) dequeue_events() []InputEvent {
	last_event:= if mouse.events.len > 0 { mouse.events.last() } else {
			InputEvent{}
	}
	//println("opening ${kb.location}")
	mouse.file = os.open(mouse.location) or {
		panic("file ${mouse.location} not found")
	}

	mut events := []InputEvent{}

	for {
		mut iev := InputEvent{}
		mouse.file.read_struct[InputEvent](mut iev) or {
			break
		}
		if iev.event_timestamp > last_event.event_timestamp {
			iev.typ = iev.typ >> 0
			iev.code = iev.code >> 0
			iev.x = iev.x >> 0
			events << iev
		}
	}
	//println("closing ${kb.location}")
	mouse.file.close()
	return events
}
pub fn (mut self Mouse) refresh_state() Mouse {
	events := self.dequeue_events()
	//println("found ${kb.events.len}")
	for ev in events {
		self.pressed[key_code_from_int(ev.code >> 8)]=ev
	}
	self.events = []
	self.events << events
	return self
}
