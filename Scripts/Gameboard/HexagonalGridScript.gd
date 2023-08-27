extends Node

const cell_factory = preload("res://BoardUI/gameboard/Cell.tscn")
var map_size := Vector2()
var grid = []
var cell_size # TODO export this to sonme singleton


func set_up_grid(size:Vector2):
    map_size = size
    var cell = cell_factory.instance()
    cell_size = cell.get_size()
    var col = map_size.x
    var row = map_size.y
    
    for x in range(col):
        grid.append([])
        grid[x]=[]        
        for y in range(row):
            grid[x].append([])
            grid[x][y]=create_hex(x, y)

func create_hex(x : int, y : int):
    var cell = cell_factory.instance()
    var position = get_screen_position(x, y)
    cell.position = position
    cell.init_cell(Vector2(x, y), position)
    add_child(cell)
    
    return cell

func get_screen_position(x : int, y : int) -> Vector2: 
     var offsetX = 0
     var size = cell_size.y/2
     if (y%2)==0:
        offsetX = size/1.2 # in theory it should size/2
     else:
        offsetX = 0
   
     var posx =  (size * sqrt(3) * x) + offsetX
     var posy = (size * 3/2) * y
     return Vector2(posx, posy)
