extends Node3D
class_name PlayerInterface

var enemy_scene = preload("res://enemies/basic_enemy_v2/basic_enemy_v2.tscn")
var melee_enemy_scene = preload("res://enemies/melee_enemy/melee_enemy.tscn")
var dummy_scene = preload("res://enemies/dummy/dummy.tscn")
var machine_gunner_scene = preload("res://enemies/machine_gunner_enemy/machine_gunner_enemy.tscn")

var spawn_scenes = [dummy_scene, enemy_scene, melee_enemy_scene, machine_gunner_scene]

@onready var player:Player = $player

var is_wait_for_respawn:bool = false

func spawn_enemy(scene:PackedScene):
	var enemy:Killable = scene.instantiate()
	enemy.set_target(player)
	owner.add_child(enemy)
	enemy.set_owner(owner)
	enemy.global_position = player.global_position + player.cursor.position

func process_spawns():
	if Input.is_action_just_pressed("spawn_0"):
		spawn_enemy(spawn_scenes[0])
	if Input.is_action_just_pressed("spawn_1"):
		spawn_enemy(spawn_scenes[1])
	if Input.is_action_just_pressed("spawn_2"):
		spawn_enemy(spawn_scenes[2])
	if Input.is_action_just_pressed("spawn_3"):
		spawn_enemy(spawn_scenes[3])
	if Input.is_action_just_pressed("spawn_4") and len(spawn_scenes) > 4:
		spawn_enemy(spawn_scenes[4])
	if Input.is_action_just_pressed("spawn_5") and len(spawn_scenes) > 5:
		spawn_enemy(spawn_scenes[5])

func process_inputs(delta):
	if is_wait_for_respawn:
		if Input.is_action_just_pressed("restart"):
			restart()
	
	# SWITCHING WEAPONS
	if Input.is_action_just_pressed("next_weapon"):
		player.next_weapon()
	if Input.is_action_just_pressed("prev_weapon"):
		player.prev_weapon()
	
	# ALT FIRE
	if Input.is_action_just_pressed("alt_fire"):
		player.alt_fire()
	if Input.is_action_just_released("alt_fire"):
		player.alt_fire_stop()
	
	# MELEE
	if Input.is_action_just_pressed("melee"):
		player.melee()
	if Input.is_action_just_released("melee"):
		pass
	
	# EXIT 
	if Input.is_action_just_pressed("pause"):
		get_tree().quit(0)

	# SPAWNS
	process_spawns()
	
	# SHOOTING
	if Input.is_action_just_pressed("shoot"):
		player.shoot()
	if Input.is_action_just_released("shoot"):
		player.stop_shooting()
	
	# DASHING
	if Input.is_action_just_pressed("dash"):
		player.dash()
		return

	# 
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.move(direction)

func player_died(_player_entity:Player, _player_name:String):
	player.main_hud.show_death()
	get_tree().paused = true
	is_wait_for_respawn = true

func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

func refill_health(how_much:float=-1):
	player.refill_health(how_much)

func _process(delta: float) -> void:
	process_inputs(delta)
