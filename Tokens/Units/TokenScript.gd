extends KinematicBody2D
class_name UnitToken

onready var fire_ray := $FireRay
onready var shot_vfx := $ShotVFX
onready var rof_timer := $ROFTimer
onready var nav_agent := $NavigationAgent
onready var path_points := $PathPoints
onready var range_finder := $RangeFinder/CollisionShape
onready var cell := $HexagonalBG

onready var unit_logic := $UnitLogic
var path_queue : Array = []

# in_range means that if we have a target_enemy set, the enemy is in range
var in_range = false
var target_enemy = null
var target_location = null
# enemy_contact means we have non-specific target  enemy in range
var enemy_contact = false
var enemy_queue = []

var max_speed
var max_range = 3 # this is just a factor to multiply the actual range
var range_distance = 1.0 # the actual range
var shot_distance
var cell_width = 1.0
var rate_of_fire = 3 # seconds
var hit_points = 100

var can_fire = true
enum {GROUND = 1, AIR = 2}

var first = true

func _ready():
    nav_agent.set_target_location(position)
    path_points.set_as_toplevel(true)
    _set_up()


func _set_up():
    # Cell size and background for icons should be the same size
    # Set range of attack for this unit
    cell_width = cell.texture.get_size().x
    range_distance =  cell_width * max_range + cell_width/2 
    range_finder.shape.radius = range_distance
    fire_ray.cast_to = Vector2(range_distance, 0)
    rof_timer.set_wait_time(rate_of_fire)
    shot_distance = cell_width
    shot_vfx.position.x = shot_distance
    # set what units can attack
    
    # Set the icon for this unit
    # Set the player faction
  # set stats for the unit
 
func _physics_process(delta):

     if Input.is_action_just_pressed("rmb"):
        var angle = position.angle_to(get_global_mouse_position())
        rotate_aim(get_global_mouse_position())
        shot_vfx.play()

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

func _should_attack():
    return (is_instance_valid(target_enemy) or not enemy_queue.empty())

func _should_chase():
    return (in_range or enemy_contact)
    
#TODO create bullets and vfx for the actual attack
func _attack():

    var enemy = _get_valid_enemy() 
    # need function to check if can attack the actual enemy
    if enemy and can_fire:
        can_fire = false
        rof_timer.start()
        rotate_aim(enemy.position)
        #Do damage to whoever is there
        if fire_ray.is_colliding():
            var object = fire_ray.get_collider()
            #check for function in object
            #calculate bonus/reduction damage
            object._damage()
        
func _chase():
    pass

func rotate_aim(enemy_position):
    var angle = position.angle_to(enemy_position)#.position)
    fire_ray.rotation = angle

    # direct damage & area damge
    var x = cos(angle)*shot_distance
    var y = sin(angle)*shot_distance
    shot_vfx.rotation = angle
    shot_vfx.position = Vector2(x,y)
    

func _get_valid_enemy():
    # priority to attack target given by player
    if in_range and _is_valid_target(target_enemy):
        return target_enemy
    elif enemy_contact and _is_valid_target(enemy_queue[0]):
        return enemy_queue[0]
    return null

func _is_alive():
    return hit_points <= 0

func _on_NavigationAgent_target_reached():
    var updated_path = path_points.points
    
    if updated_path.size() > 2:
        updated_path.remove(0)
        path_points.points = updated_path


func _on_RangeFinder_body_exited(body):
    var index_array = enemy_queue.find(body)
    # if targeted enemy died reset in_range var
    if body == enemy_contact:
        in_range = false
    
    # if anyone died remove from queue
    if index_array >= 0 and _is_valid_target(body):
        enemy_queue.remove(index_array)

    
    if enemy_queue.empty():
        enemy_contact = false
        
func _is_valid_target(body):
    # if the body is recently dead but not removed yet i.e. dead animation
    return (body.has_method("_is_alive") and body._is_alive()) or not is_instance_valid(body)

func _on_RangeFinder_body_entered(body):
    enemy_contact = true
    var found = enemy_queue.find(body)
    #if enemy is a new one
    if found == -1:
        enemy_queue.append(body)


func _on_ROFTimer_timeout():
    can_fire = true
