extends Camera3D
class_name Camera3PV

@export var follow:Node3D

# this class follows "follow" in XZ plane based on springs and how
# follow is positioned on the screen

# is used to determine how fast camera is moving right now
var velocity:Vector3 = Vector3.ZERO

# rigidity of springs that pull camera
@export var rigidity:float = 0.5


func _ready() -> void:
	pass

func get_follow_position_on_screen() -> Vector2:
	return unproject_position(follow.position)

func get_forces_on_screen() -> Vector2:
	var viewport_size = get_viewport().size
	var follow_pos = get_follow_position_on_screen()
	var delta_x = viewport_size.x / 2 - follow_pos.x
	var delta_y = viewport_size.y / 2 - follow_pos.y
	return Vector2(delta_x, delta_y)

func _process(delta: float) -> void:
	pass
