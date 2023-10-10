extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var spr = $Sprite
onready var debugger = $Debugger
var rad = 0.0
var angle  = 0.0
var pos = 0
# Called when the node enters the scene tree for the first time.
func _ready():
    rad = spr.position.x
    debugger.add_property(self, "rotation", "")
    debugger.add_property(self, "angle", "")
    debugger.add_property(self, "pos", "")
    debugger.add_property(self, "position", "")


func _input(event):
 if event is InputEventMouseMotion:
     pos = get_global_mouse_position()
     angle = (position.angle_to(pos))
     self.look_at(pos)
    
     var x = cos(angle)*rad
     var y = sin(angle)*rad
     spr.position = Vector2(x,y)
    
