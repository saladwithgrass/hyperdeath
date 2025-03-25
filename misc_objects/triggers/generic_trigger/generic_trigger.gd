extends Area3D
class_name GenericTrigger

@export var one_time_use:bool = true

func on_triggered(entity:Node3D):
	pass

func _on_body_entered(body: Node3D) -> void:
	on_triggered(body)
	if one_time_use:
		$trigger_hitbox.set_deferred("disabled", true)
