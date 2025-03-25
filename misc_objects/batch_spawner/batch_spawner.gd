extends Node3D
class_name BatchSpawner

var spawned_entities:int = 0

signal someone_died(who:Node3D, name:String)
signal everyone_died()

func entity_died(who:Node3D, name:String):
	spawned_entities -= 1
	someone_died.emit(who, name)
	if spawned_entities == 0:
		everyone_died.emit()

func spawn() -> Array:
	var result = []
	for child in get_children():
		if child is SpawnPoint:
			var new_entity = child.spawn()
			result.append(new_entity)
			new_entity.was_killed.connect(self.entity_died)
			spawned_entities += 1
	return result
