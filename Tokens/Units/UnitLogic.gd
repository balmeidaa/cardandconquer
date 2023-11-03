extends Node2D


onready var states_map = {
    "idle": $States/Idle,
    "move": $States/Move,
    "attack": $States/Attack
}

var current_state = null
var prev_state = null

enum STANCES {
    hold_fire,
    defensive,    
    aggresive
   }

var current_stance = null

func _ready():
    current_state = $States/Idle
    _change_state("idle")
    for state_node in $States.get_children():
        state_node.connect("finished", self, "_change_state")
        state_node._set_up(owner)
   

func _physics_process(delta):
    current_state._update(delta)
    
func _change_state(next_state):
    current_state.exit()
    
    if next_state == "previous":
        current_state.enter()
        return

    else:
        var new_state = states_map[next_state]
        current_state = new_state
        prev_state = current_state

    # additional logic for other elements
    match current_stance:
        "aggresive":
            if owner._should_attack():
                if owner._should_chase():
                    owner._chase()
                    _change_state("move")
                else:
                    _change_state("attack")
                    owner._attack()
            elif owner._should_move():
                _change_state("move")
            else:
                _change_state("idle")
        # attacks only enemies in range  but not chases   
        "defensive":
            if owner._should_attack():
                _change_state("attack")
                owner._attack()
            elif owner._should_move():
                _change_state("move")
            else:
                _change_state("idle")
        "holdfire":
        # Only attacks targeted enemy and noone else
            if owner._should_attack_target():
                if owner.in_range:
                    _change_state("attack")
                    owner._attack()
                else:
                    owner._chase()
                    _change_state("move")
                  
            elif owner._should_move():
                _change_state("move")
            else:
                _change_state("idle")


    if next_state != "previous":
        current_state.enter()
