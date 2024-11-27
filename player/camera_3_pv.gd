extends Node3D

@onready var main_cam = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(main_cam)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
