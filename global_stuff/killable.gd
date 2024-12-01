extends CharacterBody3D
class_name Killable

var health:int
var is_being_parried:bool = false

func deal_damage(damage:int):
	health -= damage
	if (health <= 0):
		kill()

func kill():
	queue_free()
