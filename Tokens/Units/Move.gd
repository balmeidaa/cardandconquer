extends "res://Scripts/StateMachine/State.gd"

func enter():
    pass

func handle_input(event):
#move to generic state function
    if Input.is_action_just_pressed("lmb"):
        owner._move_to(get_global_mouse_position())
        emit_signal("finished", "move")
#    if Input.is_action_just_released("rmb"):
#        emit_signal("finished", "attack")
    return .handle_input(event)

func _update(delta):
    if owner.nav_agent.is_target_reached() and not owner.path_queue.empty():
        owner.nav_agent.set_target_location(owner.path_queue[0])
        owner.path_queue.remove(0)
    elif not owner.nav_agent.is_target_reached():
        var direction = owner.position.direction_to(owner.nav_agent.get_next_location())
        var distance = owner.position.distance_to(owner.nav_agent.get_next_location())
        var speed = distance / delta 
        var velocity = direction * clamp(speed, 20, 250)
        # update visual path 
        var updated_path = owner.path_points.points
        updated_path[0] = owner.position
        owner.path_points.points = updated_path

        # move unit
        owner.move_and_slide(velocity)
    else:
        _clear_path()
        emit_signal("finished", "idle")
        return
    
    emit_signal("finished", "move")


func _clear_path():
    owner.nav_agent.set_target_location(owner.position)
    owner.path_points.clear_points()
    owner.path_queue.clear()

func _arrived_to_location():
    return owner.nav_agent.is_target_reached() and owner.path_queue.empty()
