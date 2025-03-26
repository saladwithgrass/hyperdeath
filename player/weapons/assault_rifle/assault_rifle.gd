extends Weapon

var bullet_scene = preload("res://misc_objects/heavy bullet/heavy_bullet.tscn")
var is_shot_on_cd:bool = false
var is_shooting:bool = false

func _ready():
	shot_timer.autostart = false
	shot_timer.one_shot = false
	shot_timer.wait_time = delay_between_shots

func shoot():
	fire()
	shot_timer.start()

func fire():
	var bullet = bullet_scene.instantiate()
	bullet.position = muzzle.global_position
	get_tree().get_root().add_child(bullet)
	bullet.set_new_direction($shot_direction.global_position - muzzle.global_position)

func stop_shooting():
	shot_timer.stop()

func shot_cd_elapsed():
	fire()
