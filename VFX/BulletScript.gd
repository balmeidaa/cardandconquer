extends Sprite
 
onready var tween = $Tween as Tween
 
var speed
var angle
var distance = null
var traveled_dist = 0.0
var origin:Vector2

func _process(delta):
    # check if bullet traveled enough distance
    if distance == null:
        return 
    traveled_dist = origin.distance_to(self.global_position)
    if traveled_dist >= distance:
        destroy()
    
    var current_pos = self.global_position
    var x = current_pos.x + cos(angle) * distance * delta*.5;
    var y = current_pos.y + sin(angle) * distance * delta *.5;

    self.global_position = Vector2(x, y)
    
    
    
func create_bullet(origin: Vector2, angle:float, distance: float, speed:float):
    print(angle)
    self.origin = origin
    self.global_position = origin
    self.speed = speed
    self.angle = deg2rad(angle)
    self.distance = distance

func destroy():
    call_deferred("queue_free")
    
