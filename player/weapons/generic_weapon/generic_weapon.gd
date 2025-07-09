extends Node3D
class_name Weapon

@export var damage:float = 1.
@export var delay_between_shots:float = 0.5
@export var automatic:bool = false
@export var flash_time:float = 0.2

@onready var muzzle_flash:Light3D = $muzzle/muzzle_flash
@onready var shot_timer:Timer = $shot_timer
@onready var muzzle_flash_timer:Timer = $muzzle_flash_timer
@onready var muzzle:Marker3D = $muzzle

@onready var max_muzzle_energy = $muzzle/muzzle_flash.light_energy

func activate_muzzle_flash():
	muzzle_flash.visible = true
	muzzle_flash.light_energy = max_muzzle_energy
	muzzle_flash_timer.start(flash_time)

func adjust_flash_brightness():
	var time_percentage = muzzle_flash_timer.time_left / flash_time
	muzzle_flash.light_energy = time_percentage * time_percentage * max_muzzle_energy

func muzzle_flash_timeout() -> void:
	muzzle_flash.visible = false

func _process(delta: float) -> void:
	adjust_flash_brightness()

func shot_cd_elapsed():
	pass

func shoot():
	pass

func stop_shooting():
	pass

func alt_fire_start():
	pass

func alt_fire_stop():
	pass
