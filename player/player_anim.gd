extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var angle:float = 0
const angle_delta:float = 0.01

@onready var look_object = $"../look_object"
@onready var torso = $torso
@onready var skeleton:Skeleton3D = $run4/godot_rig/Skeleton3D
var new_rotation

func look_at_object(delta):
    var torso_bone = skeleton.find_bone("spine_01")
    torso.look_at(look_object.global_position, Vector3.UP, true) 
    new_rotation = Quaternion.from_euler(torso.rotation)
    skeleton.set_bone_pose_rotation(torso_bone, new_rotation)


@onready var anim_player:AnimationPlayer = $run4/AnimationPlayer

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

    
    if Input.is_action_just_pressed("shoot"):
        anim_player.play("Shoot Pistol")
    else:
        anim_player.play("Run")
    
    look_at_object(delta)
    
    move_and_slide()
