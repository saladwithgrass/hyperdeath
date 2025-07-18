extends Weapon

var ray_scene = preload("res://weapons/histcan_rays/blue_ray.tscn")

# alt fire functions like this:
# it starts charging and charges for one second
# before one second, damage scales from 1 to max_before_full_charge
# when fully charged, damage jumps to full_charge_damage
const full_charge_damage = 20
const max_before_full_charge = 10
const min_before_full_charge = 1
const min_charge_color = Color(100, 0, 0, 1)
const max_charge_color = Color.RED
var charge_gradient:Gradient = Gradient.new()
const time_to_charge = 1

var is_shot_on_cd:bool = false

enum ChargeStates {
    not_charging,
    charging,
    fully_charged,
    on_cd
}
var charge_state:ChargeStates = ChargeStates.not_charging

func _ready():
    charge_gradient.add_point(0, min_charge_color)
    charge_gradient.add_point(max_before_full_charge, max_charge_color)
    is_automatic = false
    shot_timer.autostart = false
    shot_timer.one_shot = false
    shot_timer.wait_time = delay_between_shots

func detect_collisions(damage = self.damage):
    var ray:RayCast3D = $"shot ray"
    var length = 100
    if ray.get_collider() != null:
        length = (ray.get_collision_point() - muzzle.global_position).length()
    for body in $shot_cylinder.get_overlapping_bodies():
        var distance_sq = (ray.global_position - body.global_position).length_squared()
        if body is Killable and distance_sq <= length*length:
            body.deal_damage(damage)
    return length

func spawn_ray(ray_length, color:Color = Color.BLACK, new_emission_strength = 0):
    var ray = ray_scene.instantiate()
    ray.scale.z = ray_length
    if color != Color.BLACK:
        print("color_is_not_black")
        ray.set_color(color, new_emission_strength)
    get_tree().root.add_child(ray)
    ray.global_position = muzzle.global_position
    ray.look_at($"shot direct".global_position)

func shoot():
    activate_muzzle_flash()
    if is_shot_on_cd:
        return
    charge_state = ChargeStates.not_charging
    spawn_ray(detect_collisions())
    shot_timer.start()
    is_shot_on_cd = true
    
func shot_cd_elapsed():
    if is_shot_on_cd:
        is_shot_on_cd = false
        return
    if charge_state == ChargeStates.charging:
        charge_state = ChargeStates.fully_charged
        

func alt_fire_start():
    charge_state = ChargeStates.charging
    shot_timer.start(time_to_charge)

func alt_fire_stop():
    if charge_state == ChargeStates.fully_charged:
        spawn_ray(detect_collisions(full_charge_damage), Color.RED, 15)
        return
    if charge_state == ChargeStates.charging:
        var charged_damage = max_before_full_charge * (1 - shot_timer.time_left / time_to_charge)
        charged_damage = max(charged_damage, min_before_full_charge)
        var new_color = charge_gradient.sample(charged_damage)
        spawn_ray(detect_collisions(charged_damage), new_color, charged_damage)
        return
