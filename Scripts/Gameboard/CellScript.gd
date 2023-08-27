extends Node2D
 
var cell_coord := Vector2.ZERO
var pixel_coord := Vector2.ZERO


func get_size():
    return $CellSprite.texture.get_size()

func init_cell(cell_c:Vector2, pixel_c:Vector2):
    cell_coord = cell_c
    pixel_coord = pixel_c



func _on_ClickableArea_input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton:
        return pixel_coord


