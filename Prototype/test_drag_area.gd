extends Node2D
 
onready var u1 = $UnitToken
onready var u2 = $UnitToken2
onready var ue = $UnitTokenEnemy

var index = 0
const file_loader_factory = preload("res://Scripts/FileLoader/ReadFilesScript.gd")
var file_loader

func _ready():
    BoardEventHandler.set_root(get_tree().get_root())
    file_loader = file_loader_factory.new()
    var da = file_loader.load_file("res://unit_definition.csv")
    
    u1._set_up('player', da['rifle_squad'])
    u2._set_up('pc', da['rifle_squad'])
    ue._set_up('pc', da['rifle_squad']) 
    
    u1.change_stance("aggresive")
   # u1.get_node("Debugger").hide()
#    u2.get_node("Debugger").hide()
#    ue.get_node("Debugger").hide()
    ue.get_node("PathPoints").hide()
    u1.get_node("PathPoints").hide()
     

#func _process(delta):
#    if is_instance_valid(ue):
#        match(index):
#            0:
#                ue._add_point_to_path(Vector2(0,0))
#            1:
#                ue._add_point_to_path(Vector2(1000,0))
#            2:
#                ue._add_point_to_path(Vector2(1000,1000))
#            3:
#                ue._add_point_to_path(Vector2(0,1000))
#            _:
#                index = 0


func _on_Timer_timeout():
    index += 1
