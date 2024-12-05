extends CharacterBody3D
class_name Killable

@export var max_health:float
var health:int
var is_being_parried:bool = false

signal taken_damage(name:String, damage:int)
signal was_killed(name:String)

func _ready():
	var logger:EventLogger = get_tree().get_first_node_in_group('Logger')
	connect('taken_damage', logger.new_damage_message)
	connect('was_killed', logger.new_kill_message)

func set_target(new_target):
	pass

func deal_damage(damage:int):
	taken_damage.emit(name, damage)
	health -= damage
	if (health <= 0):
		kill()

func kill():
	print(name)
	was_killed.emit(name)
	queue_free()
