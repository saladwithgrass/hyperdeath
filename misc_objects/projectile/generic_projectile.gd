extends CharacterBody3D
class_name  Projectile

const speed = Globals.bullet_speed
var damage = 1
var lifetime = 7 # s

func set_new_velocity(new_velocity:Vector3):
	velocity = new_velocity
	look_at(velocity + position)

func set_new_direction(new_direction:Vector3):
	velocity = new_direction.normalized() * speed
	look_at(velocity + global_position)

func _physics_process(delta):
	
	if (lifetime <= 0):
		queue_free()
	lifetime -= delta
	var collision := move_and_collide(velocity*delta)
	# print(delta, collision)
	if collision != null:
		# print(collision)
		if collision.get_collider() is Killable:
			collision.get_collider().deal_damage(damage)
		queue_free()

func on_parry(direction:Vector3):
	pass
