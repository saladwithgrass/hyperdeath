extends Killable
class_name GenericEnemy

# variables used for navigation
@onready var nav_agent = $navigation_agent
@export var target:Killable

# variables that determine attack capabilities
@export var can_shoot:bool = true
@export var can_melee:bool = false

# projectile variable that is spawned when shooting
@export var projectile_template:Projectile

# basic parameters
const max_health = 5
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

# spawn a new projectile and send it
func shoot():
	pass

# do a melee
# FIXME is not done yet
func melee():
	pass

# refill health
func _ready():
	health = max_health

func process():
	pass
