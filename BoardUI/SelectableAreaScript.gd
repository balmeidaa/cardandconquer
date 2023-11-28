extends Node2D

var dragging = false  # are we currently dragging?
var selected_units = []  # array of selected units
var drag_start = Vector2.ZERO  # location where the drag begian
var select_rect = RectangleShape2D.new()
const blue =  Color(0.59, 0.86, 1.0,0.4)
var drag_end  = Vector2.ZERO 
var selected = 0


func _unhandled_input(event):
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
        # When the mouse button is pressed, then the dragging starts
        if event.pressed:
            if selected_units.size() == 0:
                dragging = true
                drag_start = event.position
            else:
                for unit in selected_units:
                    unit.collider._set_selected(false)
                    selected_units = []
            dragging = true
            drag_start = event.position
            
        elif dragging:
            dragging = false
            drag_end = event.position
            update()
            drag_end = event.position
            select_rect.extents = (drag_end - drag_start) / 2
            var space = get_world_2d().direct_space_state
            var query = Physics2DShapeQueryParameters.new()
            query.collide_with_bodies = true
            query.set_shape(select_rect)
            query.transform = Transform2D(0, (drag_end + drag_start)/2)
            selected_units = space.intersect_shape(query)
            selected = selected_units.size() 
            for unit in selected_units:
                unit.collider._set_selected(true)
                
    if event is InputEventMouseMotion and dragging:
        update()

func _draw():
    if dragging:
        draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
                blue, true)
