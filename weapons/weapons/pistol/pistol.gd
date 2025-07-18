extends Weapon

var bullet_scene = preload("res://weapons/projectiles/bullet/bullet.tscn")
var is_shot_on_cd:bool = false

func _ready():
    super._ready()

func shoot():
    activate_muzzle_flash()
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
