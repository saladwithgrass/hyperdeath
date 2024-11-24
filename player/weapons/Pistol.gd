extends Weapon

var bullet_scene = preload("res://misc_objects/bullet/bullet.tscn")
var shot_timer:Timer = Timer.new()
var is_shot_on_cd:bool = false

@onready var muzzle = $muzzle

func _ready():
	damage = 1
	delay_between_shots = 0.3
	automatic = false
	shot_timer.autostart = false
	shot_timer.one_shot = true
	shot_timer.connect("timeout", shot_cd_elapsed)
	add_child(shot_timer)

func shoot():
	if is_shot_on_cd:
		return
	is_shot_on_cd = true
	var bullet = bullet_scene.instantiate()
	bullet.position = muzzle.global_position
	get_tree().get_root().add_child(bullet)
	bullet.set_new_direction($shot_direction.global_position - muzzle.global_position)
	shot_timer.start(delay_between_shots)

func shot_cd_elapsed():
	is_shot_on_cd = false
