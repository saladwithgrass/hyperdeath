extends Camera3D
class_name Camera3PV

@export var follow:Node3D

# this class follows "follow" in XZ plane based on springs and how
# follow is positioned on the screen

# is used to determine how fast camera is moving right now
var velocity:Vector3 = Vector3.ZERO

# rigidity of springs that pull camera
@export var rigidity:float = 0.5

# damping mechanism
@export var spring_damp:float = 5

# directions in world space that correspond to movement up_and_down
@export var floor_level:float = 0
var floor_plane:Plane = Plane(Vector3.UP, floor_level)

# these determine in which direction camera will move in 3d
# when it has to move up or right in screen space 
var up_direction:Vector3 = Vector3(0, 0, 0)
var right_direction:Vector3 = Vector3(0, 0, 0)

func project_screen_to_plane(screen_pos: Vector2, plane: Plane = floor_plane) -> Vector3:
	# Get the ray origin and direction from the camera
	var ray_origin = project_ray_origin(screen_pos)
	var ray_direction = project_ray_normal(screen_pos)

	# Use the plane's intersect_ray method to find the intersection point
	var intersection = plane.intersects_ray(ray_origin, ray_direction)
	return intersection

func _ready() -> void:
	
	
	# set up directions
	
	# get viewport size to get points on it
	var viewport_size = get_viewport().size

	# set screen center in 3d plane
	var center_3d_pos = project_screen_to_plane(viewport_size/2)
	# first get a vector from center to up center
	var up_3d_pos = project_screen_to_plane(Vector2(viewport_size.x / 2, 0))
	up_direction = (up_3d_pos - center_3d_pos).normalized()
	
	# then get a vector from center to right center
	var right_3d_pos = project_screen_to_plane(Vector2(0, viewport_size.y/2))
	right_direction = (right_3d_pos - center_3d_pos).normalized()

	# FIXME maybe a bug here since right_direction x and y must be same

func get_follow_position_on_screen() -> Vector2i:
	return unproject_position(follow.global_position)

func get_forces_on_screen() -> Vector2:
	var viewport_size = get_viewport().size
	var follow_pos = get_follow_position_on_screen()
	return rigidity * (viewport_size / 2 - follow_pos)

func _process(delta: float) -> void:
	# get forces in 2d
	var forces = get_forces_on_screen()
	
	# convert forces to 3d
	var forces_3d = Vector3.ZERO
	forces_3d += forces.y * up_direction
	forces_3d += forces.x * right_direction
	forces_3d -= velocity  * spring_damp
	velocity += forces_3d * delta
	global_position += velocity * delta
