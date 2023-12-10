extends "res://Scripts/StateMachine/State.gd"


func _update(_delta):
    var enemy = owner._get_valid_enemy()
    if enemy:
        print('get_rotated')
        owner.rotate_aim(enemy)
    
func handle_input(event):
    if owner.unit_selected:
        if Input.is_action_pressed("ui_alt") and Input.is_action_just_pressed("rmb"):
            owner._add_point_to_path(get_global_mouse_position())
            emit_signal("finished", "move")
            
        elif Input.is_action_just_pressed("rmb"):
            owner._move_to(get_global_mouse_position())
            emit_signal("finished", "move")
        
#        if Input.is_action_just_pressed("rmb"):
#            emit_signal("finished", "attack")
        
        if Input.is_action_just_pressed("aggresive_stance"):
            owner.change_stance('aggresive')
        
        if Input.is_action_just_pressed("defensive_stance"):
            owner.change_stance('defensive')
   
        if Input.is_action_just_pressed("hold_stance"):
            owner.change_stance('holdfire')
