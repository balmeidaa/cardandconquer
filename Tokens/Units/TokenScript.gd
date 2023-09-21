extends KinematicBody2D


onready var nav_agent := $NavigationAgent
onready var path_points := $PathPoints

onready var states_map = {
    "idle": $States/Idle,
    "move": $States/Move,
    "moveattack": $States/MoveAttack,
    "attack": $States/Attack,
}

var current_state = null
var states_stack = []


var path_queue : Array = []
var direction 
var velocity
var max_speed
var distance
var in_range = false

func _ready():
    nav_agent.set_target_location(position)
    path_points.set_as_toplevel(true)
    
    states_stack.push_front($States/Idle)
    current_state = states_stack[0]
    
    for state_node in $States.get_children():
        state_node.connect("finished", self, "_change_state")
        

    _change_state("idle")
   
func _change_state(next_state):
    current_state.exit()
    
    if next_state == "previous":
        states_stack.pop_front()
    #encolar estado previo
    elif next_state in ["move"]:
        states_stack.push_front(states_map[next_state])
    #con prioridad
    else:
        var new_state = states_map[next_state]
        states_stack[0] = new_state

    # additional logic for other elements
    match next_state:
        "attack":
           pass
        "move":
            pass
        "idle":
            pass
    current_state = states_stack[0]
    if next_state != "previous":
        current_state.enter()


 
    
func _physics_process(delta):
    current_state._update(delta)


func _input(event):
    #TODO CHECK IF WE ARE IN RANGE
    if event.is_action_pressed("rmb"):
        if current_state == $States/Attack:
            return
        _change_state("attack")
        return
    current_state.handle_input(event)

func _move_to(coord:Vector2):
    var last_target = nav_agent.get_next_location()
    nav_agent.set_target_location(coord)
    if nav_agent.is_target_reachable():
        if  path_points.points.empty():
            path_points.points = [position]
            
        path_points.add_point(coord) 
        path_queue.append(coord)

    nav_agent.set_target_location(last_target)

func _on_NavigationAgent_target_reached():
    var updated_path = path_points.points
    
    if updated_path.size() > 2:
        updated_path.remove(0)
        path_points.points = updated_path
