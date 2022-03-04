/// Proc overriden by libdebug_server.so
/proc/enable_debugging(mode, port)
	CRASH("Debugger not initialised.")

/proc/debug_initialise()
	call("/root/.byond/bin/libdebug_server.so", "auxtools_init")()
	enable_debugging("BACKGROUND", 2448)
