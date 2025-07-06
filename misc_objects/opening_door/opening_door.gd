extends Node3D
class_name OpeningDoor

@export var is_closed:bool = true

func _ready() -> void:
	if is_closed:
		close()
	else:
		open()

func open():
	$door/hitbox.set_deferred("disabled", true)
	visible = false

func close():
	$door/hitbox.set_deferred("disabled", false)
	visible = true
