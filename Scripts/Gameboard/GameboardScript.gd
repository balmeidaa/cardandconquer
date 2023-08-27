extends Node2D

const card_factory = preload("res://BoardUI/CardTemplate.tscn")
const grid_factory = preload("res://BoardUI/Grid.tscn")


#Controls Hand, discard pile, hexagonal grid.
func _on_Timer_timeout():
    #$Hand.add_child(card_factory.instance())
    #$Timer.start()
    pass
    
func _ready():
    var grid = grid_factory.instance()
    grid.set_up_grid(Vector2(5,5))
    add_child(grid)
    
 
