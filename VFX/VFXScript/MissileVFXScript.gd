extends Node2D


export var speed : float
var angle : float
var distance = null

export(PackedScene) var explosionVFX

var traveled_dist = 0.0
var origin:Vector2
var root

func _ready():
    self.z_index = 900
    root = BoardEventHandler.root

func _process(delta):
    # check if the missile traveled enough distance
    if distance == null:
        return 
    traveled_dist = origin.distance_to(self.global_position)
    if traveled_dist >= distance:
        var explosion = explosionVFX.instance()
        explosion.global_position = self.global_position
        root.add_child(explosion)
        destroy()
    
    var current_pos = self.global_position
    var x = current_pos.x + cos(rotation) * distance/speed * delta 
    var y = current_pos.y + sin(rotation) * distance/speed * delta 

    self.global_position = Vector2(x, y)
    
    
    
func create_missile(origin: Vector2, angle:float, distance: float):
    self.origin = origin
    self.global_position = origin
    self.rotation = angle
    self.distance = distance

func destroy():
    call_deferred("queue_free")
