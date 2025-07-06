extends Control
class_name HelpMenu

var all_actions = InputMap.get_actions()

func filter_default_actions():
	var cleaned_actions = []
	for action in all_actions:
		if not action.to_lower().begins_with("ui_"):
			cleaned_actions.append(action)
	all_actions = cleaned_actions

var movement_actions = [
	"forward",
	"left",
	"backward",
	"right",
	"dash",
]

var shooting_actions = [
	"shoot",
	"alt_fire"
]

var switching_weapons = [
	"next_weapon",
	"prev_weapon"
]

var other_actions = []

func fill_other_actions():
	for action_name in all_actions:
		var belongs_to_class = false
		for action_class in all_action_classes.keys():
			if action_name in all_action_classes[action_class] and action_class != "OTHER":
				belongs_to_class = true
				print(action_name)
				break
		if not belongs_to_class:
			other_actions.append(action_name)
		

var all_action_classes = {
	"MOVEMENT" : movement_actions,
	"SHOOTING" : shooting_actions,
	"SWITCHING_WEAPONS" : switching_weapons,
	"OTHER" : other_actions,
}



func _ready() -> void:
	# all_actions = InputMap.get_actions()
	filter_default_actions()
	fill_other_actions()
	generate_keyboard_help()

var action_map_separator = "  --  "
var indent = "    "

var stuff_to_replace = {
	"(Physical)" : "",
	"Kp" : "NUMPAD"
}

func clean_action_up(action:String):
	for to_replace in stuff_to_replace.keys():
		action = action.replace(to_replace, stuff_to_replace[to_replace])
	return action

func get_action_mapping(action:String):
	var events = InputMap.action_get_events(action)
	if len(events) != 0:
		return InputMap.action_get_events(action)[0].as_text()
	
	return "NOT_MAPPED"

func generate_action_class(main_tree:Tree, action_class:String, timed:bool=true):
	var class_subtree = main_tree.create_item()
	class_subtree.set_text(0, action_class.capitalize())
	for action in all_action_classes[action_class]:
		var action_name = ""
		# add indent
		action_name += indent
		# add action itself
		action_name += action
		# get keymap
		var cur_action_map = get_action_mapping(action)
		cur_action_map = clean_action_up(cur_action_map)
		
		# wait for some time to create "loading" animation
		if timed:
			await get_tree().create_timer(randf_range(0, 0.15)).timeout
		
		# create child
		var cur_label = main_tree.create_item(class_subtree)
		# set text
		cur_label.set_text(0, action_name)
		cur_label.set_text(1, cur_action_map)
		cur_label.set_text_alignment(0, HORIZONTAL_ALIGNMENT_LEFT)

func clear_children(node:Control):
	for child in $all_actions.get_children():
		clear_children(child)
		child.queue_free()
		
func clear_actions():
	$all_actions.clear()

func generate_keyboard_help():
	clear_actions()
	var all_keys = all_action_classes.keys()
	var tree_root = $all_actions.create_item()
	tree_root.set_text(0, "INPUT MAP")
	for action_class in all_keys:
		await generate_action_class($all_actions, action_class)
