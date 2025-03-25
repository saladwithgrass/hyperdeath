extends Node3D
class_name OpeningDoor

func open():
	$door/hitbox.disabled = true
	visible = false
