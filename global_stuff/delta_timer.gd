class_name DeltaTimer
var time_elapsed
var to_call:Callable

func _init(to_call_init):
		to_call = to_call_init

func check(delta = 0):
		time_elapsed -= delta
		if (time_elapsed <= 0):
			to_call.call()

func start(time_init):
	time_elapsed = time_init
