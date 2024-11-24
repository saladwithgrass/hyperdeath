extends Projectile

# so this is the most generic bullen imaginable
# this one gains speed of 100 when parried
var speed_after_parry = 100
var parry_material = preload("res://misc_objects/bullet/parried_bullet.tres")

func on_parry(direction:Vector3):
	$rig.material_overlay = parry_material
	$rig.set_surface_override_material(0, parry_material)
	velocity = direction.normalized() * speed_after_parry
	look_at(position + velocity)
