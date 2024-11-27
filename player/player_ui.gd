extends Node3D
class_name PlayerUI

@export var camera:Node3D
@export var player:CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_mouse_projection():
	var mouse_pos = get_viewport().get_mouse_position()
	print(mouse_pos)
	return camera.project_from_screen(mouse_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
