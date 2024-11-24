extends Killable

var player

func _ready():
	player = get_tree().get_nodes_in_group("player_group")[0]

func deal_damage(damage):
	player.damage_log("dummy", damage)

func kill():
	pass
