extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var anim_player:AnimationPlayer = $player_anim/AnimationPlayer

func play_anim(anim_name: String) -> void:
	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity.x = input_dir.x * SPEED
	velocity.z = input_dir.y * SPEED
	if velocity.length_squared() == 0:
		anim_player.play("Idle")
	else:
		anim_player.play("Run")
	if Input.is_action_just_pressed("shoot"):
		anim_player.play("Shoot Pistol")

	move_and_slide()
