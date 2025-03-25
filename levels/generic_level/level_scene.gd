extends Node3D
class_name LevelScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_window().grab_focus()

func get_player(idx:int=0):
	return get_tree().get_nodes_in_group("player_group")[idx]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('toggle_fullscreen'):
		var cur_mode = DisplayServer.window_get_mode()
		if cur_mode == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif cur_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			print('UNKNOWN WINDOW MODE')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
