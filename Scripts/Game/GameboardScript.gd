extends Node2D

#const card_factory = preload("res://BoardUI/CardTemplate.tscn")
#const grid_factory = preload("res://BoardUI/Grid.tscn")

onready var debugger = $Camera2D/UICanvasLayer/Debugger
onready var unit := $UnitToken
onready var structy := $StructureTemplate
var clic_pos
#Controls Hand, discard pile, hexagonal grid.
func _on_Timer_timeout():
    #$Hand.add_child(card_factory.instance())
    #$Timer.start()
    pass
    
func _ready():
    BoardEventHandler.connect("cell_clicked", self, "test_unit_move")
    BoardEventHandler.set_root(get_tree().get_root())
#    var grid = grid_factory.instance()
#    grid.set_up_grid(Vector2(5,5))
#    add_child(grid)
    debugger.add_property($Camera2D, "new_position", "")
 

 
