extends CharacterBody3D
class_name Killable

@export var max_health:float
var health:int
var is_being_parried:bool = false

func set_target(new_target):
	pass

func deal_damage(damage:int):
	health -= damage
	if (health <= 0):
		kill()

func kill():
	queue_free()
