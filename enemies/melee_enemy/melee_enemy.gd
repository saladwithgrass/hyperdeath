extends Killable

# this one is faster than player
# always knows where the player is
@onready var nav_agent = $navigation_agent
# just runs and fucks shit up

@onready var health_display = $health_display
const max_health = 5

const melee_cd = 0.8 # s
var is_melee_on_cd:bool = false

const melee_duration = 0.2 # s
const melee_windup = 0.2 # s
var is_meleeing: bool = false
var is_melee_on_windup = false
var melee_damage = 3
const melee_reach = 1.4 # m

const speed = 10
var target

const gravity = Globals.g

func deal_damage(damage):
	health -= damage
	if (health <= 0):
		kill()
	health_display.update_display(health)

func _ready():
	health = max_health
	health_display.max_health = max_health
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = melee_reach
	$rig/melee_hitbox/melee_col.scale = Vector3(melee_reach, 1, 1)

# navigation
func set_target(new_target):
	target = new_target

func update_target_location():
	nav_agent.target_position = target.position

func get_next_location():
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	velocity = new_velocity

# actions
func melee():
	if is_melee_on_cd or is_melee_on_windup:
		return
	is_melee_on_windup = true
	$rig/body.get_active_material(0).emission_enabled = true
	$melee_timer.start(melee_windup)

func _physics_process(delta):
	health_display.look_at_screen()
	# check if it has to move to the player
	# 0.9 is there just to account for some errors

	if ($rig/melee_hitbox/melee_marker.global_position - target.position).length() <= melee_reach * 1.2:
		velocity = Vector3.ZERO
		melee()
	else:
		update_target_location()
		get_next_location()
	$rig.look_at(target.position)
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

func _on_melee_timer_timeout():
	if is_melee_on_windup:
		is_meleeing = true
		is_melee_on_cd = true
		is_melee_on_windup = false
		$rig/melee_hitbox/melee_col.disabled = false
		$rig/body.get_active_material(0).emission_enabled = false
		$melee_timer.start(melee_duration)
		return
	if is_meleeing:
		is_meleeing = false
		is_melee_on_cd = true
		$rig/melee_hitbox/melee_col.disabled = true
		$melee_timer.start(melee_cd)
		return
	if is_melee_on_cd:
		is_melee_on_cd = false

func _on_melee_hitbox_body_entered(body):
	if is_being_parried:
		return
	if body is Killable:
		body.deal_damage(melee_damage)
