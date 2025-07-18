extends Node3D
class_name Weapon

enum WeaponType {
    Shotgun,
    SingleProjectile,
    Hitscan
}

@export var damage:float = 1.
@export var delay_between_shots:float = 0.5
@export var is_automatic:bool = false
@export var flash_time:float = 0.2
@export var weapon_type:WeaponType
@export var path_to_projectile:String = "res://weapons/projectiles/bullet/bullet.tscn"

@export var path_to_config:String = "res://weapons/weapons/generic_weapon/generic_weapon.ini"

@onready var muzzle_flash:Light3D = $muzzle/muzzle_flash
@onready var shot_timer:Timer = $shot_timer
@onready var muzzle_flash_timer:Timer = $muzzle_flash_timer
@onready var muzzle:Marker3D = $muzzle

@onready var max_muzzle_energy = $muzzle/muzzle_flash.light_energy

# damage=1.0
# fire_rate= 1.0
# path_to_model="res://models/weapons/heavy assault rifle.glb"
# path_to_projectile="res://weapons/projectiles/bullet/bullet.tscn"
# is_automatic=0
# has_alt_fire= 0
# weapon_type="SingleProjectile"

func load_from_config():
    const parameters_section := "weapon_parameters"
    const damage_key := "damage"
    const fire_rate_key := "fire_ray"
    const path_to_projectile_key := "path_to_projectile"
    const is_automatic_key := "is_automatic"
    const weapon_type_key := "weapon_type"
    
    var config:ConfigFile = ConfigFile.new()
    var err:Error = config.load(path_to_config)
    if err != OK:
        print("FAILED TO LOAD CONFIG. USING DEFAULT")
        return
    
    var sections:Array = config.get_sections()
    if sections.has(parameters_section):
        damage = config.get_value(parameters_section, damage_key, damage)
        var fire_rate:float = config.get_value(parameters_section, fire_rate_key, 1 / delay_between_shots)
        delay_between_shots = 1 / fire_rate
        is_automatic = config.get_value(parameters_section, is_automatic_key, is_automatic)
        var weapon_type_string:String = config.get_value(parameters_section, weapon_type_key, weapon_type)
        weapon_type = WeaponType.get(weapon_type_string)
        if weapon_type == WeaponType.Shotgun or weapon_type == WeaponType.SingleProjectile:
            path_to_projectile = config.get_value(parameters_section, path_to_projectile_key, path_to_projectile)        

func _ready():
    load_from_config()

func activate_muzzle_flash():
    muzzle_flash.visible = true
    muzzle_flash.light_energy = max_muzzle_energy
    muzzle_flash_timer.start(flash_time)

func adjust_flash_brightness():
    var time_percentage = muzzle_flash_timer.time_left / flash_time
    muzzle_flash.light_energy = time_percentage * time_percentage * max_muzzle_energy

func muzzle_flash_timeout() -> void:
    muzzle_flash.visible = false

func _process(delta: float) -> void:
    adjust_flash_brightness()

func shot_cd_elapsed():
    pass

func shoot():
    pass

func stop_shooting():
    pass

func alt_fire_start():
    pass

func alt_fire_stop():
    pass
