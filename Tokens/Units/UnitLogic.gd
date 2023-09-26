extends Node2D


onready var states_map = {
    "idle": $States/Idle,
    "move": $States/Move,
    "attack": $States/Attack
}

var current_state = null
var states_stack = []


func _ready():

    states_stack.push_front($States/Idle)
    current_state = states_stack[0]

    for state_node in $States.get_children():
        state_node.connect("finished", self, "_change_state")
        state_node._set_up(owner)
        
    _change_state("idle")

func _physics_process(delta):
    current_state._update(delta)
    
func _change_state(next_state):
    current_state.exit()
    
    if next_state == "previous":
        current_state.enter()
        return
    #encolar estado previous
    elif next_state in ["attack", "move"]:
        states_stack.push_front(states_map[next_state])
    #con prioridad
    else:
        var new_state = states_map[next_state]
        states_stack[0] = new_state

    # additional logic for other elements
    match next_state:
        "aggresive":
           pass
        "defensive":
            pass
        "holdfire":
            pass
        "attack":
            pass
    
    current_state = states_stack[0]
    if next_state != "previous":
        current_state.enter()
