extends Sprite
 
 
var speed
var angle
var distance = null
var traveled_dist = 0.0
var origin:Vector2

func _ready():
   
    self.z_index = 900

func _process(delta):
    # check if bullet traveled enough distance
    if distance == null:
        return 
    traveled_dist = origin.distance_to(self.global_position)
    if traveled_dist >= distance:
        destroy()
    
    var current_pos = self.global_position
    var x = current_pos.x + cos(angle) * distance/speed * delta 
    var y = current_pos.y + sin(angle) * distance/speed * delta 

    self.global_position = Vector2(x, y)
    
    
    
func create_bullet(origin_o: Vector2, angle:float, distance: float, speed:float):
    self.origin = origin_o
    self.global_position = origin
    self.speed = speed
    self.angle = rotation + deg2rad(angle)
    self.distance = distance

func destroy():
    call_deferred("queue_free")
    
