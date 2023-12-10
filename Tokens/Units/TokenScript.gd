extends KinematicBody2D
class_name UnitToken

 
export(PackedScene) var explosion_vfx

onready var fire_ray := $FireRay
onready var shot_vfx := $ShotVFX
onready var rof_timer := $ROFTimer
onready var aim_timer := $AimTimer
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

var unit_selected = false setget _set_selected

var max_speed
var max_range = 3 # this is just a factor to multiply the actual range
var range_distance = 0.0 # the actual range that is calculated
var shot_distance
var cell_width = 1.0
var rate_of_fire = 1 # seconds
var hit_points = 100
var aim_time = 0.4

var aim_angle = 0.0
var can_fire = true

onready var debugger = $Debugger
var faction = ''
var unit_type = ''
var can_attack = ''

# const as reference
var AIR_GROUND = []
const GROUND = ['infantry', 'vehicle_ground', 'structure']
const AIR = ['vehicle_air']


func _ready():
    ####
    # UNIT DEBUGGER
    ####
    debugger.dynamic_font.size = 35
   # debugger.add_property(self, "hit_points", "")
    debugger.add_property($UnitLogic, "current_state", "")
    debugger.add_property($UnitLogic, "current_stance", "")
    ######
    nav_agent.set_target_location(position)
    path_points.set_as_toplevel(true)
    #_set_up()
 
func _set_up():
    AIR_GROUND.append_array(GROUND)
    AIR_GROUND.append_array(AIR)
    
    self.add_to_group(faction)
    self.add_to_group(unit_type)
 
    
    # Cell size and background for icons should be the same size
    # Set range of attack for this unit
    cell_width = cell.texture.get_size().x
    range_distance =  cell_width * max_range + cell_width/2 
    range_finder.shape.radius = range_distance
    fire_ray.cast_to = Vector2(range_distance, 0)
    rof_timer.set_wait_time(rate_of_fire)
    shot_distance = cell_width
    shot_vfx.position.x = shot_distance
    
    aim_timer.set_wait_time(aim_time)
    # set what units can attack
    
    # Set the icon for this unit
    # Set the player faction
  # set stats for the unit
 
func _physics_process(delta):
    pass

func _input(event):
    unit_logic.current_state.handle_input(event)

func _add_point_to_path(coord:Vector2):
    var last_target_position = nav_agent.get_next_location()
    nav_agent.set_target_location(coord)
    if nav_agent.is_target_reachable():
        _add_visual_point_path(coord)
        path_queue.append(coord)

    nav_agent.set_target_location(last_target_position)

func _move_to(coord:Vector2):
    var last_target_position = nav_agent.get_next_location()
    nav_agent.set_target_location(coord)
    if nav_agent.is_target_reachable():
        _clear_path()
        _add_visual_point_path(coord)
        path_queue.append(coord)
    else:
         nav_agent.set_target_location(last_target_position)

func _add_visual_point_path(coord:Vector2):
    if  path_points.points.empty():
            path_points.points = [position]  
    path_points.add_point(coord) 

func _should_attack_target():
    return true if target_enemy else false
    
    
func _should_attack():
    return (is_instance_valid(target_enemy) or not enemy_queue.empty())

func _should_move():
    return true if target_location else false

func _should_chase():
    return (in_range or enemy_contact)
    
func _fire():
    # Do damage to whoever is there
    shot_vfx.play()
    var explosion = explosion_vfx.instance()
    explosion.set_as_toplevel(true)
    explosion.z_index = 900
    
    if fire_ray.is_colliding():
        var object = fire_ray.get_collider()
        explosion.position = object.position
        
    else:
        var x = cos(deg2rad(aim_angle)) * range_distance
        var y = sin(deg2rad(aim_angle)) * range_distance
        explosion.position = Vector2(x, y)
    add_child(explosion)  
        #check for function in object
        #check for direct fire or damage in area
        #calculate bonus/reduction damage
        #object._damage()
        

func _attack():
    var enemy = _get_valid_enemy() 
    # need function to check if can attack the actual enemy
    if enemy and can_fire:
        can_fire = false
        rof_timer.start()
        rotate_aim(enemy)
        aim_timer.start()
            
        
func _chase():
    if target_enemy and not in_range:
        target_location = target_enemy.position
    elif enemy_queue[0] and not enemy_contact:
         target_location =  enemy_queue[0].position

func rotate_aim(enemy):
    aim_angle = position.angle_to_point(enemy.position) + PI
    fire_ray.rotation = aim_angle
    
    var x = cos(aim_angle)*shot_distance
    var y = sin(aim_angle)*shot_distance
    shot_vfx.rotation = aim_angle
    shot_vfx.position = Vector2(x,y)
    

func _get_valid_enemy():
    # priority to attack target given by player
    if in_range and _is_valid_target(target_enemy):
        return target_enemy
    elif enemy_contact and not enemy_queue.empty():
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
    if body == target_enemy:
        in_range = false
    
    # if anyone died remove from queue
    if index_array >= 0 and _is_valid_target(body):
        enemy_queue.remove(index_array)

    if enemy_queue.empty():
        enemy_contact = false
        
func _is_valid_target(body):
    # if the body is recently dead but not removed yet i.e. dead animation
    return (body.has_method("_is_alive") and body._is_alive()) or not is_instance_valid(body)

func _clear_path():
    path_points.points = []
    path_queue = []

func _on_RangeFinder_body_entered(body):
    #if we found targeted enemy in range
    
    if body.is_in_group(faction):
        return

    if body == target_enemy:
        in_range = true
        return
        
    enemy_contact = true
    var found = enemy_queue.find(body)
    #if enemy is a new one
    if found == -1:
        enemy_queue.append(body)


func _on_ROFTimer_timeout():
    can_fire = true

func _on_AimTimer_timeout():
    _fire()

func _set_selected(selected):
    unit_selected = selected
    cell.material.set_shader_param("active", selected)

func _set_enemy_target(enemy):
    # check unit faction is different --- TODO ignore allies units
    if faction in enemy.groups:
        return
    for type in can_attack:
        if type in enemy.groups:
            target_enemy = enemy.unit
            target_location = target_enemy.position
            break

    

func _on_UnitToken_input_event(_viewport, event, _shape_idx):

    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
        print(self)
        self._set_selected(true)

    if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
        var unit= {"unit": self, "groups": self.get_groups()}
        BoardEventHandler.unit_info(unit)


func change_stance(new_stance):
    $UnitLogic._set_stance(new_stance)
