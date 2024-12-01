extends Killable
class_name GenericEnemy

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
	health = max_health

func _process(delta: float) -> void:
	$rig.look_at(target.position)


func _on_attack_timer_timeout() -> void:
	print('shooting')
	shoot()
