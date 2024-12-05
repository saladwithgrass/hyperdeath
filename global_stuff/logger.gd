extends Control
class_name EventLogger

var entries:Array[String] = []

@export var max_entries = 100
@export var kill_msg_template:String = "%s was killed"
@export var damage_msg_template:String = "%s was damaged for %d"
signal player_log(msg:String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func new_entry(msg:String):
	if entries.size() == max_entries:
		entries.remove_at(0)
	entries.append(msg)
	print('logged ', msg)

func new_kill_message(who:String):
	who = who.replace('_', ' ')
	var msg = kill_msg_template % who
	player_log.emit(msg)
	new_entry(msg)
	
func new_damage_message(who:String, damage:int):
	who = who.replace('_', ' ')
	var msg = damage_msg_template % [who, damage]
	player_log.emit(msg)
	new_entry(msg)
