extends GenericTrigger
class_name SpawnTrigger


func on_triggered(entity:Node3D):
	var result:Array[Node3D] = []
	if entity.is_in_group("player_group"):
		for spawner in $spawners.get_children():
			if spawner is BatchSpawner:
				result.append_array(spawner.spawn())
	return result
