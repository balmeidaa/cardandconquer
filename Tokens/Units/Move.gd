extends "res://Scripts/StateMachine/UnitState.gd"

func enter():
    pass

func _update(delta):
    if parent.nav_agent.is_target_reached() and not parent.path_queue.empty():
        parent.nav_agent.set_target_location(parent.path_queue[0])
        parent.path_queue.remove(0)
    elif not parent.nav_agent.is_target_reached():
        var direction = parent.position.direction_to(parent.nav_agent.get_next_location())
        var distance = parent.position.distance_to(parent.nav_agent.get_next_location())
        var speed = distance / delta 
        # change 250 for max speed of each unit
        var velocity = direction * clamp(speed, 20, 250)
        # update visual path 
 
        var updated_path = parent.path_points.points
        if updated_path.size() > 0:
            updated_path[0] = parent.position
            parent.path_points.points = updated_path

        # move unit
        parent.move_and_slide(velocity)
    else:
        _clear_path()
        emit_signal("finished", "idle")
        return
    
    emit_signal("finished", "previous")


func _clear_path():
    parent.nav_agent.set_target_location(parent.position)
    parent.path_points.clear_points()
    parent.path_queue.clear()

func _arrived_to_location():
    return parent.nav_agent.is_target_reached() and parent.path_queue.empty()
