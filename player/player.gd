extends Killable

# external scenes
var bullet_scene = preload("res://misc_objects/bullet/bullet.tscn")
var enemy_scene = preload("res://enemies/basic_enemy/basic_enemy.tscn")
var melee_enemy_scene = preload("res://enemies/melee_enemy/melee_enemy.tscn")
var dummy_scene = preload("res://enemies/dummy/dummy.tscn")
# child nodes
@onready var cursor = $cursor
@onready var rig = $rig
@onready var gun_muzzle = $rig/gun_muzzle
@onready var melee_hitbox = $rig/melee_hitbox/melee_col
@onready var melee_timer = $melee_timer
@onready var dash_timer = $dash_timer
@onready var pistol:Weapon = $rig/gun_muzzle/Pistol
@onready var assault_rifle:Weapon = $rig/gun_muzzle/assault_rifle
@onready var railgun:Weapon = $"rig/gun_muzzle/railgun v1"
@onready var weapon = pistol

# health value
const max_health = Globals.player_health

# movement values
const SPEED = Globals.player_speed
const JUMP_VELOCITY = Globals.player_jump_velocity
const dash_velocity = Globals.player_dash_velocity
const dash_duration = Globals.player_dash_duration
var gravity = Globals.g
var mouse_direction:Vector3

# cooldowns
# dash
const dash_cd = Globals.player_dash_cd
var is_dashing:bool = false
var is_dash_on_cd:bool = false

const melee_duration = Globals.player_melee_duration
const melee_cd = Globals.player_melee_cd
var is_meleeing:bool = false
var is_melee_on_cd:bool = false

#damage values
const melee_damage = Globals.player_melee_damage

# UI elemets
@onready var ui = $ui
@onready var dash_indicator:Label = $ui/background/dash_status
const dash_indicator_symbols_amount = 10
@onready var health_indicator:Label = $ui/background/health_status
const flash_after_damage = 0.15
var vitality_timer = -1

@onready var col_mask = get_collision_mask()
@onready var col_layer = get_collision_layer()


@onready var weapons = [pistol, assault_rifle, railgun]
var current_weapon = 0

@onready var camera = $camera3pv/Camera3D

func _ready():
	print($camera3pv.main_cam)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	health = Globals.player_health
	$temp_floor.visible = false

# Killable override
func kill():
	return
	print("player killed")

func deal_damage(damage):
	health -= damage
	if (health <= 0):
		kill()
	vitality_timer = flash_after_damage
	health_indicator.label_settings.font_color = Color.RED

# visual updates
func look_at_cursor():
	var player_pos = global_transform.origin
	var drop_plane = Plane(Vector3(0, 1, 0), player_pos.y)
	var ray_len = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_len
	var cursor_pos = drop_plane.intersects_ray(from, to)
	if cursor_pos != null:
		cursor.global_transform.origin = cursor_pos # + Vector3(0, 1, 0)
		mouse_direction = cursor_pos
		mouse_direction.y = 1
		rig.look_at(mouse_direction, Vector3(0, 1, 0))
		weapon.look_at(mouse_direction)

func update_indicators():
	# update health
	var health_text = str(health) + "/" + str(max_health)
	health_indicator.text = health_text
	# update dash
	if (is_dash_on_cd):
		dash_indicator.label_settings.font_color = Color.RED
		var dash_percentage = (dash_cd - dash_timer.time_left) / dash_cd
		var dash_text = "["
		var filled_symbols = int(dash_percentage * dash_indicator_symbols_amount)
		for i in filled_symbols:
			dash_text += "#"
		for i in dash_indicator_symbols_amount - filled_symbols:
			dash_text += "."
		dash_text += "]"
		dash_indicator.text = dash_text
	else:
		dash_indicator.label_settings.font_color = Color.GREEN
		dash_indicator.text = "ready"

# player actions
func shoot():
	weapon.shoot()

func dash():
	if is_dash_on_cd:
		return
	set_collision_mask(16)
	set_collision_layer(16)
	is_dashing = true
	velocity = velocity.normalized() * dash_velocity
	if (velocity == Vector3.ZERO):
		velocity = cursor.position.normalized() * dash_velocity
	velocity.y = 0
	dash_timer.start(dash_duration)

func melee():
	if is_melee_on_cd:
		return
	melee_hitbox.disabled = false
	is_meleeing = true
	melee_timer.start(melee_duration)

func spawn_enemy(enemy_class:String):
	var enemy:Killable
	if (enemy_class == "basic_enemy"):
		enemy = enemy_scene.instantiate()
		enemy.position = self.position + cursor.position
	elif enemy_class == "melee_enemy":
		enemy = melee_enemy_scene.instantiate()
		enemy.position = self.position + cursor.position
	elif enemy_class == "dummy":
		enemy = dummy_scene.instantiate()
	enemy.position = self.position + cursor.position
	enemy.set_target(self)
	owner.add_child(enemy)
	enemy.owner = owner
# process by tick

func process_spawns():
	if Input.is_action_just_pressed("B"):
		spawn_enemy("basic_enemy")
	if Input.is_action_just_pressed("M"):
		spawn_enemy("melee_enemy")
	if Input.is_action_just_pressed("L"):
		spawn_enemy("dummy")
	

func process_inputs(delta):
	if Input.is_action_just_pressed("scroll_up"):
		weapon.visible = false
		weapon.stop_shooting()
		current_weapon += 1
		current_weapon %= weapons.size()
		weapon = weapons[current_weapon]
		weapon.visible = true

	if Input.is_action_just_pressed("scroll_down"):
		weapon.visible = false
		weapon.stop_shooting()
		current_weapon += weapons.size()
		current_weapon -= 1
		current_weapon %= weapons.size()
		weapon = weapons[current_weapon]
		weapon.visible = true
	if Input.is_action_just_pressed("RMB"):
		weapon.alt_fire_start()
	
	if Input.is_action_just_released("RMB"):
		weapon.alt_fire_stop()
	
	if Input.is_action_just_pressed("F"):
		# melee()
		$rig/melee_hitbox/melee_col.disabled = false
	if Input.is_action_just_released("F"):
		# melee()
		$rig/melee_hitbox/melee_col.disabled = true
	if Input.is_action_just_pressed("ESC"):
		get_tree().quit(0)
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY
	process_spawns()
	if Input.is_action_just_pressed("LMB"):
		shoot()
	if Input.is_action_just_released("LMB"):
		weapon.stop_shooting()
	if Input.is_action_just_pressed("shift"):
		dash()
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func _physics_process(delta):
	update_indicators()
	# process dash timer

	if (is_dashing):
		move_and_slide()
		return
	
	# process flashing color on vitality
	if (vitality_timer > 0):
		vitality_timer -= delta
	else:
		health_indicator.label_settings.font_color = Color.GREEN

	# process cursor position
	look_at_cursor()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	process_inputs(delta)
	move_and_slide()

func _on_melee_hitbox_body_entered(body):
	if body is Killable:
		body.deal_damage(melee_damage)
		body.is_being_parried = true
		return
	if body is Projectile:
		ui.screen_flash_start()
		body.on_parry(cursor.position)
		return
		var new_velocity = cursor.position.normalized() * 100
		new_velocity.y = 0
		body.set_new_velocity(new_velocity)
		return

func _on_melee_hitbox_body_exited(body):
	if body is Killable:
		body.is_being_parried = false


func _on_melee_timer_timeout():
	if is_meleeing:
		is_meleeing = false
		is_melee_on_cd = true
		melee_hitbox.disabled = true
		melee_timer.start(melee_cd)
		return
	if is_melee_on_cd:
		is_melee_on_cd = false

func _on_dash_timer_timeout():
	if is_dashing:
		is_dashing = false
		is_dash_on_cd = true
		dash_timer.start(dash_cd)
		set_collision_layer(col_layer)
		set_collision_mask(col_mask)
		return
	if is_dash_on_cd:
		is_dash_on_cd = false

func _on_melee_hitbox_area_entered(area):
	if area.is_in_group("parriable_melee"):
		if area.owner != null and area.owner is Killable:
			ui.screen_flash_start()
			area.owner.deal_damage(melee_damage*2)

func damage_log(who:String, damage:int):
	ui.damage_log(who, damage)

func kill_log(who:String):
	ui.kill_log(who)
