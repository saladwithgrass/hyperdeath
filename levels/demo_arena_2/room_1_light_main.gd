extends SpotLight3D

func turn_off():
	visible = false
	
func turn_on():
	visible = true
	
func toggle():
	visible = not visible


func _on_spawn_trigger_body_entered(_not_used) -> void:
	turn_off()
