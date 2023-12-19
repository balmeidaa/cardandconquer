extends Node2D


onready var states_map = {
    "idle": $States/Idle,
    "move": $States/Move,
    "attack": $States/Attack
}

var current_state = null
var prev_state = null

var current_stance = 'holdfire' setget _set_stance

func _ready():
    current_state = $States/Idle
    emit_signal("finished", "idle")
    for state_node in $States.get_children():
        state_node.connect("finished", self, "_change_state")
        state_node._set_up(owner)
   

func _physics_process(delta):
    current_state._update(delta)
      # additional logic for other elements
    match current_stance:
        "aggresive":
           
            if owner._should_attack():
                owner._attack()
                emit_signal("finished", "attack")
                return     
            if owner._should_chase():
                 owner._chase()
                 emit_signal("finished", "move")
                 return
                        
            elif owner._should_move():
                emit_signal("finished", "move")
                return
            else:
                emit_signal("finished", "idle")
        # attacks only enemies in range  but not chases   
        "defensive":
            if owner._should_attack():
                owner._attack()
                emit_signal("finished", "attack")
            elif owner._should_move():
               emit_signal("finished", "move")
            else:
               emit_signal("finished", "previous")
        "holdfire":
        # Only attacks targeted enemy and noone else
            if owner._should_attack_target():
                if owner.in_range:
                    owner._attack()
                    emit_signal("finished", "attack")                
                else:
                    owner._chase()
                    emit_signal("finished", "move")

            elif owner._should_move():
                emit_signal("finished", "move")
            else:
                emit_signal("finished", "idle")
    
func _change_state(next_state):
    current_state.exit()
    
    if next_state == "previous":
        current_state.enter()
        return

    else:
        var new_state = states_map[next_state]
        current_state = new_state
        prev_state = current_state

    if next_state != "previous":
        current_state.enter()

func _set_stance(new_stance):
    current_stance = new_stance
