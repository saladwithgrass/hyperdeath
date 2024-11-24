extends Marker3D
class_name HealthDisplay

var max_health

func update_display(cur_health):
	var new_text = str(cur_health) + "/" + str(max_health)
	$health.text = new_text

func look_at_screen():
	look_at(get_viewport().get_camera_3d().position)
