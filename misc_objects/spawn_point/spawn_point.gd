extends Node3D
class_name SpawnPoint

@export var entity_scene:PackedScene

signal entity_spawned(new_entity:Node3D)

func _ready() -> void:
	pass
	
func spawn():
	var new_entity = entity_scene.instantiate()
	get_tree().current_scene.add_child(new_entity)
	new_entity.set_owner(get_tree().current_scene)
	new_entity.global_position = self.global_position
	# return the spawned entity 
	# if more processing is needed
	entity_spawned.emit(new_entity)
	return new_entity
