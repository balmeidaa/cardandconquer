extends KinematicBody2D
class_name Token

onready var nav_agent := $NavigationAgent
onready var path_points := $PathPoints
onready var range_finder := $RangeFinder/CollisionShape2D
onready var cell := $HexagonalBG

onready var unit_logic := $UnitLogic
var path_queue : Array = []

var in_range = false
var target_enemy = null
var target_location = null
var enemy_contact = false
var enemy_queue = []

var max_speed
var max_range = 3

enum STANCES{
    hold_fire,
    defensive,    
    aggresive
   }

func _ready():

    nav_agent.set_target_location(position)
    path_points.set_as_toplevel(true)

    
func _set_up():
    # Cell size and background for icons should be the same size
    # Set range of attack for this unit
    var range_factor = cell.texture.get_size().x
    range_finder.shape.radius = range_factor * max_range + range_factor/2 
    # Set the icon for this unit
    # Set the player faction
  # set stats for the unit

func _physics_process(delta):
    #current_state._update(delta)
    pass


func _input(event):
    unit_logic.current_state.handle_input(event)

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


func _on_RangeFinder_body_exited(body):
    var index_array = enemy_queue.find(body)
    # if any else died remove from queue
    if index_array >= 0:
        #if the body is recently dead but not removed yet i.e. dead animation
        #REDO use a method here
        if  body.has_method("_is_alive") and body._is_alive():
            enemy_queue.remove(index_array)
        elif not is_instance_valid(body):
            enemy_queue.remove(index_array)

    if enemy_queue.empty():
        enemy_contact = false

func _on_RangeFinder_body_entered(body):
    enemy_contact = true
    var found = enemy_queue.find(body)
    #if enemy is a new one
    if found == -1:
        enemy_queue.append(body)
