extends GenericTrigger
class_name LightTrigger

@export var lights:Array[Light3D] = []
@export var delay:float = 0.
@export var disable_lights:bool = false

func actuate_lights():
	for light in lights:
		light.visible = not disable_lights

func on_triggered(entity:Node3D):
	print('light triggered:', entity)
	if delay != 0:
		$enable_timer.start(delay)
	else:
		actuate_lights()


func _on_enable_timer_timeout() -> void:
	actuate_lights()
