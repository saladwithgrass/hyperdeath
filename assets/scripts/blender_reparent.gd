@tool
extends EditorScript
# this script when reparents all meshes that have a static body child 
# so that static body has a mesh child instead

func _run():
	var root = get_scene()  # Get the currently open scene
	print(get_scene().get_owner())
	if root:
		process_all(root)
		print("Reparenting complete!")

func process_all(node: Node):
	# check that is has a static body child
	for child in node.get_children():
		if child is StaticBody3D:
			process_staticbody(child)
		process_all(child)

func process_staticbody(static_body: StaticBody3D):
	print('found static body: ', static_body.get_owner())
	# get parent
	var parent = static_body.get_parent()
	# check if it is a mesh
	if not parent is MeshInstance3D:
		return
	
	# save transforms
	var static_body_global = static_body.global_transform
	var mesh_parent_global = parent.global_transform
	
	# get grandparent
	var grandparent = parent.get_parent()
	
	# reparent static body
	parent.remove_child(static_body)
	grandparent.add_child(static_body)
	
	# reparent mesh
	grandparent.remove_child(parent)
	static_body.add_child(parent)
	
	# preserve transforms
	static_body.global_transform = static_body_global
	parent.global_transform = mesh_parent_global

	parent.set_owner(get_scene())
	static_body.set_owner(get_scene())

	for child in static_body.get_children():
		if child.get_owner() == null:
			child.set_owner(static_body.owner)
	
