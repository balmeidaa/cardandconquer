extends Node2D

export var speed := 100.0
export var amount_bullets := 7
export var dispersion_angle := 15.0
export var dispersion_origin := 5.0

onready var timer = $ROF
export(PackedScene) var bullet_sprite 

var rng = RandomNumberGenerator.new()
var origin 

func _ready():
    rng.randomize() 
    _set_up(Vector2(0,0), 1000)
#agregar el timer que cree balas y detenerlo
func _set_up(origin: Vector2, distance: float):
    origin = self.global_position + Vector2(-200, 10) #get_parent().global_position
    for i in amount_bullets:
        var vector_dispersion = Vector2(_get_rng_origin(), _get_rng_origin())
        var bullet = bullet_sprite.instance()
        
        bullet.create_bullet((origin + vector_dispersion), _get_rng_angle(), distance, speed  )
        add_child(bullet)

func _get_rng_angle():
    return rng.randi_range (-dispersion_angle, dispersion_angle)

func _get_rng_origin():
    return rng.randi_range (-dispersion_origin, dispersion_origin)
