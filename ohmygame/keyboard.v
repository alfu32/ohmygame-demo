module ohmygame

pub struct Keyboard{}
pub struct Key{
	pub mut:
	code u16
	ascii u8
	typ u16
}


pub fn (kb &Keyboard) get_keys() string {
	return "wasd"
}