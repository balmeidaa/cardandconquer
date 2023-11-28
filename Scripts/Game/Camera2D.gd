extends Camera2D

onready var tween := $Tween
const ease_tween_speed = 250
const anim_time = 0.8
var new_position = 0.0

func _process(delta):
   
    if Input.is_action_pressed("ui_up"):
        new_position = position.y - (1 * ease_tween_speed)
        tween.interpolate_property(self, "position:y", 
            position.y, new_position, anim_time,
            Tween.TRANS_BACK, Tween.EASE_OUT)
        
    if Input.is_action_pressed("ui_down"):
        new_position = position.y + (1 * ease_tween_speed)
        tween.interpolate_property(self, "position:y", 
            position.y, new_position, anim_time,
            Tween.TRANS_BACK, Tween.EASE_OUT)
            
    if Input.is_action_pressed("ui_left"):
        new_position = position.x - (1 * ease_tween_speed)
        tween.interpolate_property(self, "position:x", 
            position.x, new_position, anim_time,
            Tween.TRANS_BACK, Tween.EASE_OUT)
            
    if Input.is_action_pressed("ui_right"):
        new_position = position.x + (1 * ease_tween_speed)
        tween.interpolate_property(self, "position:x", 
            position.x, new_position, anim_time,
            Tween.TRANS_BACK, Tween.EASE_OUT)
    
    tween.start() 
