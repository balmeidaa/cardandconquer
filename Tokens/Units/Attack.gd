extends "res://Scripts/StateMachine/UnitState.gd"


func _update(_delta):
   pass

func enter():
    return

# Clean up the state. Reinitialize values like a timer
func exit():
    parent.rof_timer.start()
