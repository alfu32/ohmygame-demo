module ohmygame


pub fn test_keycodes_print() {
	number_9 := KeyCode.number_9
	println("${number_9}")
	println("${u16(number_9)}")
	println("${unsafe {KeyCode(11)}}")
}
