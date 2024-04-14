extends Node2D

onready var TweenAnimator = $Tween
onready var muzzle = $Muzzle

export(String, FILE, "*.wav") var audio_path

var rng = RandomNumberGenerator.new()

 
func _ready():
   rng.randomize()
   muzzle.modulate = Color(1, 1, 1, 0.0)
   $Audio.stream = load(audio_path)
   

func play():
    var pitch = rng.randf_range(0.9, 1.2)
    $Audio.pitch_scale = pitch
    $AnimationPlayer.play("ShotVFX")
    
func appear():    
    TweenAnimator.interpolate_property(muzzle, "modulate", 
    Color(1, 1, 1, 0.1), Color(1, 1, 1, 1), 0.1, 
    Tween.TRANS_LINEAR)
    TweenAnimator.start() 


func remove():
    TweenAnimator.interpolate_property(muzzle, "modulate", 
    Color(1, 1, 1, 1), Color(1, 1, 1, 0.0), 0.2, 
    Tween.TRANS_QUINT, Tween.EASE_IN)
    TweenAnimator.start()   
