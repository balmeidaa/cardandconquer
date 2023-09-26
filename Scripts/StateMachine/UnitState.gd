extends "res://Scripts/StateMachine/State.gd"

    
func handle_input(event):
    if Input.is_action_just_pressed("lmb"):
        owner._move_to(get_global_mouse_position())
        emit_signal("finished", "move")
    
    if Input.is_action_just_pressed("rmb"):
        emit_signal("finished", "attack")
   
    return .handle_input(event)
