extends Node2D

onready var explosion = $Explosion 
onready var TweenAnimator = $Tween

func _ready():
    explosion.modulate = Color(1, 1, 1, 0.0)
    $AnimationPlayer.play("SmokeAnim")


func appear():    
    TweenAnimator.interpolate_property(explosion, "modulate", 
    Color(1, 1, 1, 0.1), Color(1, 1, 1, 1), 0.1, 
    Tween.TRANS_QUINT, Tween.EASE_IN)
    
    TweenAnimator.interpolate_property(explosion, "scale", 
    Vector2(0.3, 0.3), Vector2(0.7, 0.7), 0.3, 
    Tween.TRANS_QUINT, Tween.EASE_IN)
    TweenAnimator.start() 


func remove():
    TweenAnimator.interpolate_property(explosion, "modulate", 
    Color(1, 1, 1, 1), Color(1, 1, 1, 0.0), 0.4, 
    Tween.TRANS_QUINT, Tween.EASE_OUT)
    TweenAnimator.interpolate_property(explosion, "scale", 
    Vector2(0.7, 0.7), Vector2(0.3, 0.3), 0.5, 
    Tween.TRANS_QUINT, Tween.EASE_OUT)
    TweenAnimator.start()   


 
