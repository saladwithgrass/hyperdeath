extends GenericEnemy
class_name MachineGunnerEnemy

@export var mag_size:int = 30
var cur_bullet_count:int = mag_size

@export var reload_time:float = 3
@export var fire_rate:float = 15
var delay_between_shots = 1.0 / fire_rate

func _ready():
	super._ready()
	$reload_timer.wait_time = reload_time
	$attack_timer.wait_time = delay_between_shots

func shoot():
	# print('bullets: ', cur_bullet_count)
	super.shoot()
	cur_bullet_count -= 1
	if cur_bullet_count == 0:
		# print('reloading')
		$attack_timer.stop()
		$reload_timer.start(reload_time)

func _process(delta: float) -> void:
	super._process(delta)


func _on_reload_timer_timeout() -> void:
	# print('reloaded')
	cur_bullet_count = mag_size
	$attack_timer.start()
