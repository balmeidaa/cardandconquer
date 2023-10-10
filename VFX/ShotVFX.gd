extends Node2D

onready var TweenAnimator = $Tween

func _ready():
   $Sprite.modulate = Color(1, 1, 1, 0.0)
   pass

func play():
    $AnimationPlayer.play("ShotVFX")
    
func appear():    
    TweenAnimator.interpolate_property($Sprite, "modulate", 
    Color(1, 1, 1, 0.1), Color(1, 1, 1, 1), 0.1, 
    Tween.TRANS_LINEAR)
    TweenAnimator.start() 


func remove():
    TweenAnimator.interpolate_property($Sprite, "modulate", 
    Color(1, 1, 1, 1), Color(1, 1, 1, 0.0), 0.2, 
    Tween.TRANS_QUINT, Tween.EASE_IN)
    TweenAnimator.start()   
