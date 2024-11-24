extends Killable

var bullet_scene = preload("res://misc_objects/bullet/bullet.tscn")

@onready var gun_muzzle = $gun_muzzle_rig/gun_muzzle
@onready var health_display = $health_display
@onready var LOS = $LOS_marker/LOS
@onready var rig = $rig

# shooting stuff
var target:Killable
const shot_cd = 1
var shot_cd_timer = 0

const max_health = 3

# movement setup
var last_target_position:Vector3
const speed = 3

const enemy_name:String = "Basic Enemy"

# navigation
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var player

# killable overrides
func kill():
	player.kill_log(enemy_name)
	queue_free()

func deal_damage(damage):
	player.damage_log(enemy_name, damage)
	health -= damage
	if (health <= 0):
		kill()
	health_display.update_display(health)
	

# pathfinding stuff
func update_target_location(new_location:Vector3):
	navigation_agent.target_position = new_location

func get_next_location():
	var current_location = global_transform.origin
	var next_location = navigation_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	velocity = new_velocity

func _ready():
	health = max_health
	health_display.max_health = max_health
	health_display.update_display(health)
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	player = get_tree().get_nodes_in_group("player_group")[0]

# shooting related functions
func set_target(new_target:Killable):
	target = new_target

func is_target_visible() -> bool:
	var collider = LOS.get_collider()
	if collider != null:
		return collider.is_in_group("player_group")
	return false

func shoot():
	$gun_muzzle_rig.look_at(target.position)
	var bullet = bullet_scene.instantiate()
	var bullet_direction = target.position - gun_muzzle.global_position
	bullet_direction.y = 0
	bullet.position = gun_muzzle.global_position
	owner.add_child(bullet)
	bullet.set_new_direction(bullet_direction)

func _physics_process(delta):
	shot_cd_timer -= delta
	health_display.look_at_screen()
	if is_target_visible():
		# print("target is visible")
		velocity = Vector3.ZERO
		last_target_position = target.position
		if shot_cd_timer <= 0:
			# print("shooting")
			shoot()
			shot_cd_timer = shot_cd
	else:
		# print("target is invisible")
		# print("moving")
		# print("target position: ", last_target_position)
		update_target_location(last_target_position)
		get_next_location()
	# print("")
	var to_look_at = last_target_position
	to_look_at.y = 1
	rig.look_at(to_look_at)
	$LOS_marker.look_at(target.position)
	move_and_slide()
