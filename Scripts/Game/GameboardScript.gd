extends Node2D

#const card_factory = preload("res://BoardUI/CardTemplate.tscn")
#const grid_factory = preload("res://BoardUI/Grid.tscn")

onready var debugger = $Camera2D/UICanvasLayer/Debugger
onready var unit := $UnitToken
var clic_pos
#Controls Hand, discard pile, hexagonal grid.
func _on_Timer_timeout():
    #$Hand.add_child(card_factory.instance())
    #$Timer.start()
    pass
    
func _ready():
   
    BoardEventHandler.connect("cell_clicked", self, "test_unit_move")
    
#    var grid = grid_factory.instance()
#    grid.set_up_grid(Vector2(5,5))
#    add_child(grid)
    debugger.add_property(self, "clic_pos", "")
    debugger.add_property(unit, "angle", "")
    debugger.add_property(unit, "position", "")



func _physics_process(delta):
      if Input.is_action_just_released("rmb"):
        clic_pos = get_global_mouse_position()
      if Input.is_action_just_released("lmb"):
         test_unit_move(get_global_mouse_position())
 
func test_unit_move(pixel_coord):
    clic_pos = pixel_coord
 
