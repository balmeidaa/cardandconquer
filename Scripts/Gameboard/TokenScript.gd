extends KinematicBody2D


onready var nav_agent := $NavigationAgent2D
onready var path := $Path

var path_q : Array = []
 
var direction 
var velocity
var max_speed
var distance
#TODO cambiar nombre de variables por algo mas claro
#Empezar a meter maquina de estados
func _ready():
    nav_agent.set_target_location(position)
    path.set_as_toplevel(true)
    
func _physics_process(delta):
    if nav_agent.is_target_reached() and not path_q.empty():
        nav_agent.set_target_location(path_q[0])
        path_q.remove(0)
    elif not _arrived_to_location():
        direction = position.direction_to(nav_agent.get_next_location())
        distance = position.distance_to(nav_agent.get_next_location())
        max_speed = distance / delta 
        velocity = direction * clamp(max_speed, 20, 250)
        move_and_slide(velocity)
    else:
        _clear_path()

func move_to(coord:Vector2):
    var last_target = nav_agent.get_next_location()
    nav_agent.set_target_location(coord)
    if nav_agent.is_target_reachable():
         if  path.points.empty():
            path.points = [position]
         path.add_point(coord)
         path_q.append(coord)

    nav_agent.set_target_location(last_target)
 
   
func _clear_path():
    nav_agent.set_target_location(position)
    path.clear_points()
    path_q.clear()

func _arrived_to_location():
    return nav_agent.is_target_reached() and path_q.empty()


