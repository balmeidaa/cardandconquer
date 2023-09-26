extends Node2D 

signal finished(next_state_name)

var parent = null

# Initialize the state. E.g. change the animation
func enter():
    return

# Clean up the state. Reinitialize values like a timer
func exit():
    return

# When we are un this state and we need to handle input
func handle_input(event):
    return

#Actual state logic
func _update(delta):
    return

func _on_animation_finished(anim_name):
    return

func _set_up(reference):
    parent = reference

