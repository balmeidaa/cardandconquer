extends Position2D

export(PackedScene) var shot_vfx

onready var fire_ray := $FireRay
onready var range_finder := $RangeFinder/CollisionShape

onready var muzzle_vfx = $MuzzleFire #defualt muzzle VFX
var shot_distance
var shot_type

const GROUND = ['infantry', 'vehicle_ground', 'structure']
const AIR = ['vehicle_air']

const air_collision_layer = 4
const ground_collision_layer = 2

func _set_up(range_distance, shotDistance, shotType):
    shot_distance = shotDistance
    shot_type = shotType
    
    range_finder.shape.radius = range_distance
    fire_ray.cast_to = Vector2(range_distance, 0)
    fire_ray.add_exception(owner)
# sets vfx for fire effect  
    match(shot_type):
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
    

func rotate_vfx(angle, position_vector):
        muzzle_vfx.rotation = angle
        muzzle_vfx.position = position_vector * shot_distance

# fix
func vfx_fire(unit_data):
     if not fire_ray.is_colliding():
        return

     var shots_fire_vfx = shot_vfx.instance()
     var x = 0.0
     var y = 0.0
     var object_position = Vector2.ZERO
   
     if fire_ray.is_colliding():
        var object = fire_ray.get_collider()
        
        
        if object.has_method("_update_hitpoints"):

            var enemy_type = object._get_type()
            object_position = object.position
            
            if enemy_type in GROUND and unit_data['can_attack_ground']:
                fire_ray.set_collision_mask(ground_collision_layer)
            elif enemy_type in AIR and unit_data['can_attack_air']:
                fire_ray.set_collision_mask(air_collision_layer)

           
            var bonus_key = 'vs_'+ enemy_type
            var bonus_damage = unit_data[bonus_key]
            var total_damage = unit_data['damage'] +  (unit_data['damage'] * bonus_damage)

            object._update_hitpoints(1.0)
    
            muzzle_vfx.play()
            add_child(shots_fire_vfx)

     else:
        
            x = cos(muzzle_vfx.rotation) * range_finder.shape.radius
            y = sin(muzzle_vfx.rotation) * range_finder.shape.radius
            object_position = to_global(Vector2(x, y))

     match(shot_type):
        "bullet":
            shots_fire_vfx.global_position = muzzle_vfx.global_position
            shots_fire_vfx.rotation = muzzle_vfx.rotation  

            var fire_distance = shots_fire_vfx.position.distance_to(object_position) + shot_distance/2
            shots_fire_vfx._set_up(fire_distance)
        "cannon":
            shots_fire_vfx.global_position = object_position
            
        "missile":
            var fire_distance = shots_fire_vfx.position.distance_to(object_position) - shot_distance/2
            shots_fire_vfx.create_missile(muzzle_vfx.global_position, muzzle_vfx.rotation, fire_distance)

        _:
            return


func _on_RangeFinder_body_entered(body):
    if self_validate(body):
        return
    if owner.has_method("_on_body_entered"):
        owner._on_body_entered(body)

func _on_RangeFinder_body_exited(body):
   if self_validate(body):
        return
   if owner.has_method("_on_body_exited"):
        owner._on_body_exited(body)

func self_validate(body):
    if body == owner:
        return true
