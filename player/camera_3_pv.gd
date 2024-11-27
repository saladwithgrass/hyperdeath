extends Node3D
class_name Camera3PV

@export var follow:Node3D
@onready var main_cam = $Camera3D
@export var desired_distance:float = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func project_from_screen(on_screen_pos):
	return $Camera3D.project_ray_normal(on_screen_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print((position - owner.position).length())
