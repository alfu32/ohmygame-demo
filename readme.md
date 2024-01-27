# ohmygame
game engine for terminal emulators

## requirements

### keyboard

the engine reads keyboard events from `/tmp/kbev/events`.
this pipe does not exist but it will be created and fed with events from `/dev/input/event*`
using ./kbevd.sh

you can run this demon in another console by running

```bash
sudo ./kbevd.sh
```

you could also install it as a system service and don't bother launching it every time.

this script manages piping events using the `cat` command.
it scans the event devices and detect which ones are keyboards,
then for each keyboard device it launches a `cat` process and
then keep watching if these processes are still running
( if not it will relaunch them )

the daemon will also empty /tmp/kbev/events every hour.

## usage


example of polling the keyboard to get all the keys that are depressed.
(the keyboards i'm using do not track more than 6 depressed keys, I don't know if this is a hardware or a software/os limitation)


```v
    import ohmygame as omg
    import time
    import term

	mut kbd := omg.Keyboard{location: "/tmp/kbev/events"}
	kbd.init()
	//println(kbd)
	println("\nstarting\n")
	term.hide_cursor()
	for _ in 1 ..100000 {

		kbd=kbd.refresh_state()
		mut pressed:=[]i32{}
		for k,v in kbd.pressed {
			if v!=0 {
				pressed << k
			}
		}
		print("\r${pressed}                       ")
		if 1 in pressed {
			break
		}
		/// print("\r${kbd.pressed.keys()}")
		time.sleep(1000*1000*1)
	}
	term.show_cursor()
	println("\ndone\n")
	println(kbd)
	kbd.close()
```
