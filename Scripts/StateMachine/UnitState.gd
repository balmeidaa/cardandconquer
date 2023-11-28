extends "res://Scripts/StateMachine/State.gd"

    
func handle_input(event):
    if owner.unit_selected:
        if Input.is_action_pressed("ui_alt") and Input.is_action_just_pressed("lmb"):
            owner._add_point_to_path(get_global_mouse_position())
            emit_signal("finished", "move")
            
        elif Input.is_action_just_pressed("lmb"):
            owner._move_to(get_global_mouse_position())
            emit_signal("finished", "move")
            
        if Input.is_action_just_pressed("rmb"):
            owner._clear_path()
            emit_signal("finished", "attack")
   
func unit_order():
    pass
