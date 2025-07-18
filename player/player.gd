extends Killable
class_name Player
# external scenes
var bullet_scene = preload("res://weapons/projectiles/bullet/bullet.tscn")

 
# child nodes
@onready var cursor = $cursor
@onready var rig = $rig
@onready var gun_muzzle = $rig/gun_muzzle
@onready var melee_hitbox = $rig/melee_hitbox/melee_col
@onready var melee_timer = $melee_timer
@onready var dash_timer = $dash_timer
@onready var pistol:Weapon = $rig/gun_muzzle/pistol
@onready var assault_rifle:Weapon = $rig/gun_muzzle/assault_rifle
@onready var railgun:Weapon = $"rig/gun_muzzle/railgun v1"
@onready var weapon = pistol

# movement values
const SPEED = Globals.player_speed
const JUMP_VELOCITY = Globals.player_jump_velocity
const dash_velocity = Globals.player_dash_velocity
const dash_duration = Globals.player_dash_duration
var gravity = Globals.g
var mouse_direction:Vector3

# cooldowns
# dash
const dash_cd = Globals.player_dash_cd
var is_dashing:bool = false
var is_dash_on_cd:bool = false

const melee_duration = Globals.player_melee_duration
const melee_cd = Globals.player_melee_cd
var is_meleeing:bool = false
var is_melee_on_cd:bool = false

#damage values
const melee_damage = Globals.player_melee_damage

# UI elemets
@export var main_hud:PlayerMainHud

# @onready var health_indicator:Label = $ui/background/health_status
# const flash_after_damage = 0.15
# var vitality_timer = -1

@onready var col_mask = get_collision_mask()
@onready var col_layer = get_collision_layer()


@onready var weapons = [pistol, assault_rifle, railgun]
var current_weapon = 0

@export var camera:Camera3PV

signal exited_screen()
signal entered_screen()

func _ready():
    # max health value
    max_health = Globals.player_health
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    health = Globals.player_health
    $temp_floor.visible = false

func refill_health(how_much:float=-1):
    if how_much != -1:
        health += how_much
    else:
        health = Globals.player_health
    main_hud.update_vitality(health, max_health)

# Killable override
func kill():
    was_killed.emit(self, "player")
    is_dead = true

func deal_damage(damage):
    health -= damage
    if (health <= 0):
        kill()
    main_hud.update_vitality(health, max_health)

# visual updates
func move_cursor():
    var player_pos = global_transform.origin
    var drop_plane = Plane(Vector3(0, 1, 0), player_pos.y)
    var ray_len = 1000
    var mouse_pos = get_viewport().get_mouse_position()
    var from = camera.project_ray_origin(mouse_pos)
    var to = from + camera.project_ray_normal(mouse_pos) * ray_len
    var cursor_pos = drop_plane.intersects_ray(from, to)
    if cursor_pos != null:
        cursor.global_transform.origin = cursor_pos # + Vector3(0, 1, 0)

func look_at_cursor():
        mouse_direction = cursor.global_transform.origin
        mouse_direction.y = 1
        rig.look_at(mouse_direction, Vector3(0, 1, 0))
        weapon.look_at(mouse_direction)

func update_indicators():
    # update dash
    if is_dash_on_cd:
        var dash_percentage = (dash_cd - dash_timer.time_left) / dash_cd
        main_hud.update_dash_indicator(dash_percentage)

# player actions
func shoot():
    weapon.shoot()

func stop_shooting():
    weapon.stop_shooting()

func next_weapon():
        weapon.visible = false
        weapon.stop_shooting()
        current_weapon += 1
        current_weapon %= weapons.size()
        weapon = weapons[current_weapon]
        weapon.visible = true

func prev_weapon():
    weapon.visible = false
    weapon.stop_shooting()
    current_weapon += weapons.size()
    current_weapon -= 1
    current_weapon %= weapons.size()
    weapon = weapons[current_weapon]
    weapon.visible = true

func alt_fire():
    weapon.alt_fire_start()

func alt_fire_stop():
    weapon.alt_fire_stop()

var prev_collision_layer
var prev_collision_mask

func dash():
    if is_dash_on_cd:
        return
    prev_collision_layer = collision_layer
    prev_collision_mask = collision_mask
    set_collision_mask(0)
    set_collision_layer(0)
    set_collision_mask_value(5, true)
    set_collision_layer_value(5, true)
    set_collision_mask_value(1, true)
    print(collision_mask)
    is_dashing = true
    velocity = velocity.normalized() * dash_velocity
    if (velocity == Vector3.ZERO):
        velocity = cursor.position.normalized() * dash_velocity
    velocity.y = 0
    dash_timer.start(dash_duration)

func move(direction):
    if is_dashing:
        return
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

func melee():
    if is_melee_on_cd:
        return
    melee_hitbox.disabled = false
    is_meleeing = true
    melee_timer.start(melee_duration)

func parry():
    $parry_timer.start()

func _physics_process(delta):
    # process cursor position
    move_cursor()
    look_at_cursor()
    update_indicators()

    
    # process dash timer
    if (is_dashing):
        move_and_slide()
        return
    
    # Add the gravity.
    if not is_on_floor():
        velocity.y -= gravity * delta

    # process_inputs(delta)
    move_and_slide()

func _on_melee_hitbox_body_entered(body):
    if body is Killable:
        body.deal_damage(melee_damage)
        body.is_being_parried = true
        return
    if body is Projectile:
        main_hud.screen_flash_start()
        body.on_parry(cursor.position)
        return
        var new_velocity = cursor.position.normalized() * 100
        new_velocity.y = 0
        body.set_new_velocity(new_velocity)
        return

func _on_melee_hitbox_body_exited(body):
    if body is Killable:
        body.is_being_parried = false

func _on_melee_timer_timeout():
    if is_meleeing:
        is_meleeing = false
        is_melee_on_cd = true
        melee_hitbox.disabled = true
        melee_timer.start(melee_cd)
        return
    if is_melee_on_cd:
        is_melee_on_cd = false

func _on_dash_timer_timeout():
    if is_dashing:
        is_dashing = false
        is_dash_on_cd = true
        dash_timer.start(dash_cd)
        set_collision_layer(prev_collision_layer)
        set_collision_mask(prev_collision_mask)
        return
    if is_dash_on_cd:
        is_dash_on_cd = false
    
    main_hud.update_dash_indicator(1)

func _on_melee_hitbox_area_entered(area):
    if area.is_in_group("parriable_melee"):
        if area.owner != null and area.owner is Killable:
            main_hud.screen_flash_start()
            area.owner.deal_damage(melee_damage*2)

func _on_visibility_checker_screen_entered() -> void:
    entered_screen.emit()

func _on_visibility_checker_screen_exited() -> void:
    exited_screen.emit()
