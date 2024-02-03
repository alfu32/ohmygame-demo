module utils


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
	return pr[(pr.len-max_len)..pr.len]
}
pub fn trim_indent(buffer [][]u8,cutset []u8) [][]u8 {
	mut max_indent:=0
	mut b :=buffer.map(it.bytestr())
	mut c:=[]string{}
	mut stop:=false
	for l in b {
		if !stop && l.trim(cutset.bytestr()) == "" {
		} else {
			stop=true
			if max_indent < l.len {
				max_indent = l.len
			}
			c << l
		}
	}
	c.reverse_in_place()
	stop=false
	mut d:=[]string{}
	//println("max_indent init:${max_indent}")
	for l in c {
		if !stop && l.trim(cutset.bytestr()) == "" {
		} else {
			stop=true
			d << l

			mut current_indent:=0
			for _,chr in l {
				//print("[${l[i]}] in ${cutset} == ")
				if cutset.contains(chr) {
					current_indent+=1
				} else {
					break
				}
			}
			//println("indent[${k}]:${current_indent}")
			if current_indent < max_indent {
				max_indent = current_indent
			}

		}
	}
	d.reverse_in_place()
	// println("max_indent final:${max_indent}")
	return d.map(it.bytes()[max_indent..])
}
pub fn buffer_to_string(buffer [][]u8) string {
	return buffer.map('|'+it.bytestr()+'|').join('\n')
}
pub fn buffer_to_numbers(buffer [][]u8) string {
	return buffer.map('|'+it.map(it.str()).join('')+'|').join('\n')
}
