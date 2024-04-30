extends KinematicBody2D
class_name UnitToken

const NOT_FOUND = -1
const FIRST_ENEMY = 0 

# scene for instancing new effects
export(PackedScene) var shot_vfx

onready var stop_timer := $StopTimer

var fire_ray = null

onready var muzzle_vfx = $MuzzleFire #defualt muzzle VFX
onready var rof_timer := $ROFTimer
onready var nav_agent := $NavigationAgent
onready var path_points := $PathPoints

onready var cell := $HexagonalBG
onready var tween := $Tween

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
var range_distance = 0.0 # max range used to shoot
var shot_distance # distance between the muzzle fire effect and the unit icon
var cell_width = 1.0

var aim_angle = 0.0
var can_fire = true

onready var debugger = $Debugger
var unit_faction = ''
var can_attack = ''

# const as reference
var AIR_GROUND = []
const GROUND = ['infantry', 'vehicle_ground', 'structure']
const AIR = ['vehicle_air']

var unit_data = {'hit_points':0}

const air_collision_layer = 4
const ground_collision_layer = 2

var hit_points = 0 #only for debug
func _ready():
   AIR_GROUND.append_array(GROUND)
   AIR_GROUND.append_array(AIR)
   ####
   # UNIT DEBUGGER
   ####
 
   debugger.dynamic_font.size = 35
   debugger.add_property(self, "hit_points", "")
#   debugger.add_property($UnitLogic, "current_state", "")
#   debugger.add_property($UnitLogic, "current_stance", "")
#   debugger.add_property(self, "range_distance", "")
#   debugger.add_property(self, "target_location", "")
#   debugger.add_property(self, "enemy_queue", "")
#   debugger.add_property(self, "enemy_contact", "")


   ######
   nav_agent.set_target_location(position)
   path_points.set_as_toplevel(true)
   #_set_up()
 
func _set_up(unit_faction, template):

   hit_points = unit_data['hit_points']
   unit_data = template.duplicate(true)
   self.unit_faction = unit_faction
   self.add_to_group(unit_faction)
   self.add_to_group(template['branch_type'])
 
   # load unit image
   var img_path = "res://Tokens/TokenImage/%s.png"
   $HexagonalBG/UnitIcon.texture = load(img_path % template['image'])
   # Cell size and background for icons should be the same size
   # Set range of attack for this unit
   cell_width = cell.texture.get_size().x
   range_distance =  cell_width * unit_data['range'] + cell_width/2 
   $RangeHandler._set_up(range_distance)
   fire_ray = $RangeHandler.fire_ray

   rof_timer.set_wait_time(template['rate_of_fire'])
   shot_distance = cell_width
  

    # sets vfx for fire effect  
   match(unit_data['shot_type']):
        "bullet":
            shot_vfx = BoardEventHandler.bullet_vfx
            muzzle_vfx = BoardEventHandler.bullets_muzzle.instance()
       
        "cannon":
            shot_vfx =  BoardEventHandler.cannon_vfx
            muzzle_vfx = BoardEventHandler.cannon_muzzle.instance()
        
        "missile":
            shot_vfx =  BoardEventHandler.missile_vfx
            muzzle_vfx = BoardEventHandler.cannon_muzzle.instance()
            muzzle_vfx.audio_path = "res://Assets/Audio/missile.wav"
            
        _:
            pass
   add_child(muzzle_vfx)
   muzzle_vfx.position.y = 0
   muzzle_vfx.position.x = shot_distance

         
   # set what units can attack
   
   # Set the icon for this unit
   # Set the player faction
  # set stats for the unit
 
func _physics_process(delta):
   hit_points = unit_data['hit_points']

func _input(event):
   unit_logic.current_state.handle_input(event)

func _add_point_to_path(coord:Vector2):
   unit_logic.current_state.send_signal("finished", "move")
   var last_target_position = nav_agent.get_next_location()
   nav_agent.set_target_location(coord)
   if nav_agent.is_target_reachable():
       _clear_enemy()
       _add_visual_point_path(coord)
       path_queue.append(coord)

   nav_agent.set_target_location(last_target_position)

func _move_to(coord:Vector2):
   _clear_path()
   unit_logic.current_state.send_signal("finished", "move")
   var last_target_position = nav_agent.get_next_location()
   nav_agent.set_target_location(coord)
   if nav_agent.is_target_reachable():
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
   var decision = (not enemy_queue.empty() and is_instance_valid(enemy_queue[0]))  or is_instance_valid(target_enemy)
   if decision == false:
        target_enemy = null
        enemy_queue = []
   return decision

func _should_move():
   return true if target_location else false

func _should_chase():
   if target_enemy != null and not in_range:
        return true
   elif enemy_queue.size() > 0 and not enemy_contact:
        return true
   return false
   
func _auto_movement():
   _move_to(target_location)
   target_location = null

func _fire():
   # Do damage to whoever is there
   if not fire_ray.is_colliding():
     return

   var shots_fire_vfx = shot_vfx.instance()
   var x = 0.0
   var y = 0.0
   var shot_pos = Vector2.ZERO
   
   if fire_ray.is_colliding():
        var object = fire_ray.get_collider()
        shot_pos = object.position
        
        if object.has_method("_update_hitpoints"):
            # add  damage modifier
            # verify if we can attack
            var enemy_type = object._get_type()

            if enemy_type in GROUND and unit_data['can_attack_ground']:
                fire_ray.set_collision_mask(ground_collision_layer)
            elif enemy_type in AIR and unit_data['can_attack_air']:
                fire_ray.set_collision_mask(air_collision_layer)

           
            var bonus_key = 'vs_'+ enemy_type
            var bonus_damage = unit_data[bonus_key]
            var total_damage = unit_data['damage'] +  (unit_data['damage'] * bonus_damage)

            object._update_hitpoints(total_damage)
   else:
        
        x = cos(aim_angle) * range_distance
        y = sin(aim_angle) * range_distance
        shot_pos = to_global(Vector2(x, y))
        
   add_child(shots_fire_vfx)
   muzzle_vfx.play()
   match(unit_data['shot_type']):
        "bullet":
            shots_fire_vfx.global_position = muzzle_vfx.global_position
            shots_fire_vfx.rotation = muzzle_vfx.rotation  

            var shot_distance = shots_fire_vfx.position.distance_to(Vector2(x, y)) + cell_width/2
            shots_fire_vfx._set_up(shot_distance)
        "cannon":
            shots_fire_vfx.global_position = shot_pos
            
        "missile":
            var shot_distance = shots_fire_vfx.position.distance_to(Vector2(x, y)) - cell_width/2
            shots_fire_vfx.create_missile(muzzle_vfx.global_position, muzzle_vfx.rotation, shot_distance)
  
        _:
            return
    

  
   
   #check for direct fire or damage in area
   #calculate bonus/reduction damage
 
   

func _attack():
   var enemy = _get_valid_enemy() 
   # need function to check if can attack the actual enemy
   if enemy and can_fire:
        unit_logic.current_state.send_signal("finished", "attack")
        can_fire = false
        rotate_aim()
        _fire()
        rof_timer.start() 
       

       
   
func _chase():
   if target_enemy and not in_range:
        if is_instance_valid(target_enemy):
            target_location = target_enemy.position
   elif enemy_queue.size() > 0 and not enemy_contact and unit_logic._get_stance()=='aggresive':
        if is_instance_valid(enemy_queue[0]):
            target_location =  enemy_queue[0].position

func rotate_aim():
   var enemy = _get_valid_enemy() 
   if is_instance_valid(enemy):
        aim_angle = position.angle_to_point(enemy.position) + PI
       
        fire_ray.rotation = aim_angle

        var x = cos(aim_angle)*shot_distance
        var y = sin(aim_angle)*shot_distance
        muzzle_vfx.rotation = aim_angle
        muzzle_vfx.position = Vector2(x,y)
   

func _get_valid_enemy():
   # priority to attack target given by player
   if  _is_valid_target(target_enemy):
        return target_enemy
   elif not enemy_queue.empty():
        return enemy_queue[0]
   return null

func _is_alive():
   return unit_data['hit_points'] > 0

func _on_NavigationAgent_target_reached():
   var updated_path = path_points.points
   
   if updated_path.size() > 2:
        updated_path.remove(0)
   path_points.points = updated_path


func _on_body_exited(body):

   var index_array = enemy_queue.find(body)
   # if targeted enemy died reset in_range var
   if body == target_enemy:
        in_range = false
        if  body.is_queued_for_deletion():
            target_enemy = null
        return
   
   # if anyone died remove from queue
   #chase enemy if its the first on the Q
   if body.is_queued_for_deletion() and index_array > NOT_FOUND:
        enemy_queue.remove(index_array)
   
   if index_array == FIRST_ENEMY and is_instance_valid(body) and unit_logic._get_stance()=='aggresive':
        target_location = body.position
        enemy_contact = false
        return
   elif index_array > NOT_FOUND:
        enemy_queue.remove(index_array)
     
   if enemy_queue.empty():
        enemy_contact = false
   
func _is_valid_target(body):
   # if the body is recently dead but not removed yet i.e. dead animation
   if not is_instance_valid(body):
        return false
   return (body.has_method("_is_alive") and body._is_alive())

func _clear_path():
   path_points.points = []
   path_queue = []
   nav_agent.set_target_location(position)

func _clear_enemy():
   target_enemy = null

func _on_body_entered(body):

   var found = NOT_FOUND
# if we found targeted enemy in range
   if body.is_in_group(unit_faction):
        return
   if not _can_attack_unit(body):
        return

   if body == target_enemy:
        in_range = true
   else:  
        enemy_contact = true
        found = enemy_queue.find(body)
        #if enemy is a new one
        if found == NOT_FOUND:
            enemy_queue.append(body)
   
   if (in_range or found == FIRST_ENEMY) and unit_logic._get_stance() =='aggresive' and stop_timer.is_stopped():
        stop_timer.start()
 

func _on_ROFTimer_timeout():
   can_fire = true


func _set_selected(selected):
   unit_selected = selected
   cell.material.set_shader_param("active", selected)

func _set_enemy_target(enemy):
   # check unit faction is different --- TODO ignore allies units
   if unit_faction in enemy.groups:
        return
   
   var found = enemy_queue.find(enemy)
   
   if found > NOT_FOUND:
        enemy_queue.remove(found)

   for type in can_attack:
        if type in enemy.groups:
            target_enemy = enemy.unit
            target_location = target_enemy.position
            break
  

func change_stance(new_stance):
   $UnitLogic._set_stance(new_stance)

func _on_StopTimer_timeout():
   target_location = null
   _clear_path()

func _update_hitpoints(damage):
   unit_data['hit_points'] = unit_data['hit_points'] - damage
   if unit_data['hit_points'] <= 0:
        can_fire = false
        tween.interpolate_property(self, "modulate", 
            Color(1, 1, 1, 0.9), Color(1, 1, 1, 0.01), 0.5, Tween.TRANS_LINEAR)
        tween.start()
        call_deferred("queue_free")



func _on_UnitToken_input_event(_viewport, event, _shape_idx):
# TODO only be able to select own units
   if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
        self._set_selected(true)

   if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
        var unit= {"unit": self, "groups": self.get_groups()}
        BoardEventHandler.unit_info(unit)

func _get_type():
    if not unit_data.has('branch_type'):
        return false
    return unit_data['branch_type']

func _can_attack_unit(body):
    var type = ''
    if not body.has_method('_get_type'):
        print('no type defined in unit')
        return false
    type = body._get_type()
    
    if type in GROUND and unit_data['can_attack_ground']:
        return true
    elif type in AIR and unit_data['can_attack_air']:
        return true
    
    return false
    
 
