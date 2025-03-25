extends SpawnTrigger
class_name SpawnTriggerDeathTrack

var spawned_entities:Array
var spawned_count:int = 0

signal all_dead()

func _ready() -> void:
	for spawner in $spawners.get_children():
		if spawner is BatchSpawner:
			spawner.someone_died.connect(self.on_entity_died)
			spawner.everyone_died.connect(self.on_all_dead)

func on_entity_died(entity:Killable=null, entity_name:String=""):
	pass

func on_all_dead():
	print('all dead')
	all_dead.emit()

func on_triggered(entity:Node3D):
	spawned_count = 0
	spawned_entities = super.on_triggered(entity)
	
