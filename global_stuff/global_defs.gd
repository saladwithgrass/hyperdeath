extends Node3D

const g = 9.8; # m/s^2

# player params
#movement
const player_speed = 8 # m/s
const player_jump_velocity = 4.5; # m/s
const player_dash_duration = 0.1 # s
const player_dash_distance = 5 # m
const player_dash_velocity = player_dash_distance / player_dash_duration
const player_dash_cd = 1 # s
# health
const player_health = 10
# melee
const player_melee_duration = 0.3
const player_melee_cd = 0.5
const player_melee_damage = 2

# projectile params
const bullet_speed = 70 # m/s
