extends Killable

var player

func deal_damage(damage):
	super.deal_damage(damage)
	health = max_health

func kill():
	pass
