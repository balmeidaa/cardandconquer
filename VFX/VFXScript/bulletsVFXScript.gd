extends Node2D

export var speed := 0.15
export var amount_bullets := 6
export var dispersion_angle := 8.0
export var dispersion_origin := 4.0
export var rof_delta := 0.4
onready var rof_timer = $ROF
export(PackedScene) var bullet_sprite 

var rng = RandomNumberGenerator.new()
var distance
var bullet_count = 0
 #remove for debug only use root from board singleton
var root

func _ready():
    self.set_as_toplevel(true)
    rng.randomize() 
    root = BoardEventHandler.root

    #remove for debug only
#    root = get_tree().get_root()
#    _set_up(1000)
    
#agregar el timer que cree balas y detenerlo
func _set_up(distance: float):
    rof_timer.start()
    self.distance = distance
    

func _get_rng_rof():
    return rng.randi_range(-rof_delta, rof_delta)

func _get_rng_angle():
    return rng.randi_range (-dispersion_angle, dispersion_angle)

func _get_rng_origin():
    return rng.randi_range (-dispersion_origin, dispersion_origin)


func _on_ROF_timeout():
    if bullet_count >= amount_bullets:
        rof_timer.stop()
        call_deferred("queue_free")
        return
        
    _create_bullet()
#    if (bullet_count % 2) == 0:
#        _create_bullet()
        
func _create_bullet():
    rof_timer.wait_time = _get_rng_rof()
 
 
    var vector_dispersion = Vector2(_get_rng_origin(), _get_rng_origin())
    var bullet = bullet_sprite.instance()
    bullet.rotation =  rotation
    bullet.create_bullet((position + vector_dispersion), _get_rng_angle(), distance, speed )
    
    root.add_child(bullet)
    bullet_count = bullet_count + 1
    
