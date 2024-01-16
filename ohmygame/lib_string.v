module ohmygame


pub fn pad_end(s string,max_len u32,pad_string string) string {
	if s.len > max_len {
		return s
	}
	return "${s}${pad_string.repeat(max_len)}"[0..max_len]
}
pub fn pad_start(s string,max_len u32,pad_string string) string {
	if s.len > max_len {
		return s
	}
	pr:="${pad_string.repeat(max_len)}${s}"
	return pr[(max_len-pr.len)..max_len]
}