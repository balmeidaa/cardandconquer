extends Node2D


onready var u1 = $UnitToken
onready var u2 = $UnitToken2
onready var ue = $UnitTokenEnemy

func _ready():
    u1.faction = 'player'
    u2.faction = 'player'
    
    u1.unit_type = 'vehicle_ground'
    u2.unit_type = 'vehicle_ground'
    
    u1.can_attack =  ['infantry', 'vehicle_ground', 'structure']
    u2.can_attack =  ['infantry', 'vehicle_ground', 'structure']
    
    
    
    ue.faction = 'pc'
    ue.unit_type = 'vehicle_ground'
    
    u1._set_up()
    u2._set_up()
    ue._set_up()
