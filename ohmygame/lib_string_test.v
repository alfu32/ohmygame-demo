module ohmygame


pub fn test_pad_end() {
	a:="abcd"
	b:=pad_end(a,3,">")
}
pub fn test_pad_start() {
	a:="abcd"
	b:=pad_start(a,3,">")
}

pub fn test_trim_indent(){
	shape:="
	sssssssssssssssssssssss .
	   ddddddddddddddddddd  .
	ddddddddddddd           .
	fffffff o               .
	gggg    o               .
	gggg                    .
	gggg                    .
	ggggg                   .
	"
	buffer:=shape.split("\n").map(it.replace("\t","    ").bytes())
	println("input untrimmed")
	println(buffer_to_string(buffer))
	trimmed:=trim_indent(buffer," ".bytes())
	println("output trimmed")
	println(buffer_to_string(trimmed))
}