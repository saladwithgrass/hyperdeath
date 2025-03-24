extends Killable
class_name GenericEnemy

# how far away enemy can see the player
@export var visibility_distance:float = 20

# variables used for navigation
@onready var nav_agent = $navigation_agent
@export var target:Killable

# variables that determine attack capabilities
@export_group("Attack Details")
@export var can_shoot:bool = true
@export var can_melee:bool = false

# projectile variable that is spawned when shooting
@export var projectile_template:PackedScene
@export var gun_muzzle:Marker3D

# basic parameters
var speed = 5

# sets target to track and attack
func set_target(new_target:Killable):
	target = new_target

# check that some point is visible
func point_is_visible(global_point:Vector3) -> bool:
	# check if the point is even in range
	if (position - global_point).length_squared() > visibility_distance**2:
		return false
	
	# get world space state
	var space_state = get_world_3d().direct_space_state
	# construct a query
	var query = PhysicsRayQueryParameters3D.create(
		$eyes.global_position,
		global_point,
		0b111
	)
	
	# cast the ray
	var result:Dictionary = space_state.intersect_ray(query)
	return len(result) != 0 and result['collider'] is Player

# check that target is actually visible
func check_target_visibility():
	# check player from head to toe
	const LOW_OFFSET = 0.
	const HIGH_OFFSET = 2.
	const MID_OFFSET = (LOW_OFFSET + HIGH_OFFSET) * 0.5
	
	var target_global_pos = self.target.global_position
	
	# check if presumed midpoint is visible
	if point_is_visible(target_global_pos + Vector3(0, MID_OFFSET, 0)):
		return true
	
	# check if presumed low point is visible
	if point_is_visible(target_global_pos + Vector3(0, LOW_OFFSET, 0)):
		return true
	
	# check if presumed high point is visible
	if point_is_visible(target_global_pos + Vector3(0, HIGH_OFFSET, 0)):
		return true
	
	# if none are visible return false
	return false 

# updates location of target
func update_target_location():
	nav_agent.target_position = target.position

# set new velocity in order to follow
# the path to target
func set_next_velocity():
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	velocity = new_velocity

# spawn a new projectile and send itt
func shoot():
	assert(can_shoot)
	if not check_target_visibility():
		return
	var bullet = projectile_template.instantiate()
	var bullet_direction = target.position - gun_muzzle.global_position
	bullet_direction.y = 0
	bullet.position = gun_muzzle.global_position
	owner.add_child(bullet)
	bullet.set_new_direction(bullet_direction)

# do a melee
# FIXME is not done yet
func melee():
	pass

# refill health
func _ready():
	super._ready()
	health = max_health

func _process(delta: float) -> void:
	if target != null:
		if check_target_visibility():
			$rig.look_at(target.position)
		else:
			update_target_location()
			set_next_velocity()
			self.move_and_slide()
			$rig.look_at(position + velocity*100)

func _on_attack_timer_timeout() -> void:
	# print('shooting')
	shoot()
