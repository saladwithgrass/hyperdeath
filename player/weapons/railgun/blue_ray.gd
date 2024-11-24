extends StaticBody3D

const time_to_disappear = 1
var disappear_timer = 1

func set_color(new_color:Color, emission_strength = 0):
	$ray_mesh.get_active_material(0).albedo_color = new_color
	$ray_mesh.get_active_material(0).emission = new_color
	if emission_strength != 0:
		$ray_mesh.get_active_material(0).emission_energy_multiplier = emission_strength

func _physics_process(delta):
	disappear_timer -= delta
	if disappear_timer <= 0:
		queue_free()
	$ray_mesh.get_active_material(0).albedo_color.a = disappear_timer / time_to_disappear
