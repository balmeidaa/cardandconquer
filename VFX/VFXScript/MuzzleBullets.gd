extends Node2D

onready var muzzle = $Sprite
onready var TweenAnimator = $Tween

var muzzleA = "res://Assets/SpritesVFX/muzzle_01.png"
var muzzleB = "res://Assets/SpritesVFX/muzzle_04.png"
var muzzleC = "res://Assets/SpritesVFX/muzzle_05.png"

var muzzle_arr = []
var rng = RandomNumberGenerator.new()

func _ready():
    muzzle_arr = [muzzleA, muzzleB, muzzleC]
    rng.randomize()
    muzzle.modulate = Color(1, 1, 1, 0.0)

func change_sprite():
   var index = rng.randi_range(0,2)
   muzzle.texture = load(muzzle_arr[index])

func play():
    $AnimationPlayer.play("Burst_fire")
    
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
