module ohmygame

// Text Color Codes
pub const ansi_color_black        = "\x1b[30m"
pub const ansi_color_red          = "\x1b[31m"
pub const ansi_color_green        = "\x1b[32m"
pub const ansi_color_yellow       = "\x1b[33m"
pub const ansi_color_blue         = "\x1b[34m"
pub const ansi_color_magenta      = "\x1b[35m"
pub const ansi_color_cyan         = "\x1b[36m"
pub const ansi_color_white        = "\x1b[37m"
pub fn ansi_color_rgb(r u8,g u8,b u8) string {
	return "\x1b[38;2;${r};${g};${b}m"
}

// Background Color Codes
pub const ansi_background_black   = "\x1b[40m"
pub const ansi_background_red     = "\x1b[41m"
pub const ansi_background_green   = "\x1b[42m"
pub const ansi_background_yellow  = "\x1b[43m"
pub const ansi_background_blue    = "\x1b[44m"
pub const ansi_background_magenta = "\x1b[45m"
pub const ansi_background_cyan    = "\x1b[46m"
pub const ansi_background_white   = "\x1b[47m"
pub fn ansi_background_rgb(r u8,g u8,b u8) string {
	return "\x1b[48;2;${r};${g};${b}m"
}

// Formatting Codes
pub const ansi_bold              = "\x1b[1m"
pub const ansi_underline         = "\x1b[4m"
pub const ansi_reversed          = "\x1b[7m"

// Reset Code
pub const ansi_color_reset       = "\x1b[0m"

// Clear screen
pub const ansi_cls               = "\x1b[2J"
pub const ansi_home              = "\x1b[H"

// Save Cursor Position
pub const ansi_save_cursor_pos    = "\x1b[s"

// Restore Cursor Position
pub const ansi_restore_cursor_pos = "\x1b[u"

// Cursor Movement
pub fn ansi_cursor_up(num int)      string { return "\x1b[${num}A" }
pub fn ansi_cursor_down(num int)    string { return "\x1b[${num}B" }
pub fn ansi_cursor_forward(num int) string { return "\x1b[${num}C" }
pub fn ansi_cursor_back(num int)    string { return "\x1b[${num}D" }

// Cursor Position
pub fn ansi_cursor_set(x int, y int)  string { return "\x1b[${x},${y}H" }

