extends Camera2D

onready var tween := $Tween
const ease_tween_speed = 350
const anim_time = 0.9
var new_position = 0.0

func _process(delta):

    if Input.is_action_pressed("ui_up"):
        new_position = position.y - (1 * ease_tween_speed)
        tween.interpolate_property(self, "position:y", 
            position.y, new_position, anim_time,
            Tween.TRANS_CIRC, Tween.EASE_OUT)

    if Input.is_action_pressed("ui_down"):
        new_position = position.y + (1 * ease_tween_speed)
        tween.interpolate_property(self, "position:y", 
            position.y, new_position, anim_time,
            Tween.TRANS_CIRC, Tween.EASE_OUT)

    if Input.is_action_pressed("ui_left"):
        new_position = position.x - (1 * ease_tween_speed)
        tween.interpolate_property(self, "position:x", 
            position.x, new_position, anim_time,
            Tween.TRANS_CIRC, Tween.EASE_OUT)

    if Input.is_action_pressed("ui_right"):
        new_position = position.x + (1 * ease_tween_speed)
        tween.interpolate_property(self, "position:x", 
            position.x, new_position, anim_time,
            Tween.TRANS_CIRC, Tween.EASE_OUT)

    tween.start() 
    

onready var debugger = $UICanvasLayer/Debugger

var dragging = false  # are we currently dragging?
var selected_units = []  # array of selected units
var drag_start = Vector2.ZERO  # location where the drag begian
var select_rect = RectangleShape2D.new()
const blue =  Color(0.59, 0.86, 1.0,0.4)
var drag_end  = Vector2.ZERO 
var selected = 0

var group_selection = 'selection1'

func _ready():
    debugger.add_property(self, "selected", "")
    BoardEventHandler.connect("unit_info", self, "send_info")


func _unhandled_input(event):
  
    if Input.is_action_just_pressed("lmb"):
        if selected_units.size() == 0:
            dragging = true
            drag_start = get_global_mouse_position()
        else:
            _toggle_unit_selection(false)
    
    elif Input.is_action_pressed("lmb"):
            drag_end = get_global_mouse_position()
            update()
    elif Input.is_action_just_released("lmb"):
            dragging = false
            drag_end = get_global_mouse_position()
            update()
            select_rect.extents = (drag_end - drag_start) / 2
            var space = get_world_2d().direct_space_state
            var query = Physics2DShapeQueryParameters.new()
            query.collide_with_bodies = true
            query.set_shape(select_rect)
            query.transform = Transform2D(0, (drag_end + drag_start)/2)
            selected_units = space.intersect_shape(query)
            _toggle_unit_selection(true)
        
    elif Input.is_action_just_pressed("rmb"):
        if selected_units.size() > 0:
            _order_units(event)      

    if event is InputEventMouseMotion and dragging:
        update()


func _order_units(event): 
    get_tree().call_group(group_selection, "_input", event)
    
func send_info(unit_info):
    if selected_units.size() == 0:
        return
    get_tree().call_group(group_selection, "_set_enemy_target", unit_info)
    

   
func _toggle_unit_selection(is_selected):
    if not is_instance_valid(self):
        return
        
    for unit in selected_units:
        unit.collider._set_selected(is_selected)
        if is_selected:
            unit.collider.add_to_group(group_selection) # change this for later other groups g1, g2 etcc
        else:
            unit.collider.remove_from_group(group_selection)
            
    if not is_selected:
        selected_units = []
        
    selected = selected_units.size() 


func _draw():
    if dragging:
        draw_rect(Rect2(drag_start,drag_end - drag_start),
                blue, true)

