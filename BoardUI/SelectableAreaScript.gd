extends Node2D

#onready var debugger = $Camera2D/UICanvasLayer/Debugger

var dragging = false  # are we currently dragging?
var selected_units = []  # array of selected units
var drag_start = Vector2.ZERO  # location where the drag begian
var select_rect = RectangleShape2D.new()
const blue =  Color(0.59, 0.86, 1.0,0.4)
var drag_end  = Vector2.ZERO 
var selected = 0

var group_selection = 'selection1'

#func _ready():
#    debugger.add_property(self, "selected", "")
#    debugger.add_property(self, "drag_start", "")
#    debugger.add_property(self, "drag_end", "")


func _unhandled_input(event):
    if event is InputEventMouseButton:
        if Input.is_action_just_pressed("lmb"):
            if selected_units.size() == 0:
                _toggle_unit_selection(false)
                dragging = true
                drag_start = event.position
        
        elif Input.is_action_pressed("lmb"):
                drag_end = event.position
                update()
        elif Input.is_action_just_released("lmb"):
                dragging = false
                drag_end = event.position
                update()
                select_rect.extents = (drag_end - drag_start) / 2
                var space = get_world_2d().direct_space_state
                var query = Physics2DShapeQueryParameters.new()
                query.collide_with_bodies = true
                query.set_shape(select_rect)
                #query.transform = Transform2D(0, (drag_end + drag_start)/2)
                selected_units = space.intersect_shape(query)
            
            # _toggle_unit_selection(true)
            
        elif Input.is_action_just_pressed("rmb"):
            if selected_units.size() > 0:
                _order_units(event)
                
    
    
        if event is InputEventMouseMotion and dragging:
            update()

# if the cursor touches an enemy, add the body and change order of movement
#check if we need to add unit or unit.collider into the group
func _order_units(event): #target_location, multi_location, enemy_target = null):

    get_tree().call_group(group_selection, "_input", event)
#    if multi_location:
#        get_tree().call_group(group_selection, "_move_to", target_location)
#    else:
#        get_tree().call_group(group_selection, "_add_point_to_path", target_location)
    
#    for unit in selected_units:
#        unit.collider._move_to(target_location) 
#        _add_point_to_path   
   
func _toggle_unit_selection(selected):
    print('ajua  ', selected)
    for unit in selected_units:
        unit.collider._set_selected(selected)
        if selected:
            unit.add_to_group(group_selection) # change this for later other groups g1, g2 etcc
        else:
            unit.remove_from_group(group_selection)
    
    if not selected:
        selected_units = []
    selected = selected_units.size() 





func _draw():
    if dragging:
        draw_rect(Rect2(drag_start,drag_end - drag_start),
                blue, true)
