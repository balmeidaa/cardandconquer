extends Node2D


onready var u1 = $UnitToken
onready var u2 = $UnitToken2
onready var ue = $UnitTokenEnemy

var index = 0

func _ready():
    u1.faction = 'player'
    u2.faction = 'pc'
    
    u1.unit_type = 'vehicle_ground'
    u2.unit_type = 'vehicle_ground'
    
    u1.can_attack =  ['infantry', 'vehicle_ground', 'structure']
    u2.can_attack =  ['infantry', 'vehicle_ground', 'structure']
    

    ue.faction = 'pc'
    ue.unit_type = 'vehicle_ground'
    
    u1._set_up()
    u2._set_up()
    ue._set_up()
    
    u1.change_stance("defensive")
   # u1.get_node("Debugger").hide()
    u2.get_node("Debugger").hide()
    ue.get_node("Debugger").hide()
    ue.get_node("PathPoints").hide()
    u1.get_node("PathPoints").hide()

func _process(delta):

    match(index):
        0:
            ue._add_point_to_path(Vector2(0,0))
        1:
            ue._add_point_to_path(Vector2(1000,0))
        2:
            ue._add_point_to_path(Vector2(1000,1000))
        3:
            ue._add_point_to_path(Vector2(0,1000))
        _:
            index = 0


func _on_Timer_timeout():
    index += 1
