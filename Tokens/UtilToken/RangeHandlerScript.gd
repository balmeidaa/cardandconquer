extends Position2D


onready var fire_ray := $FireRay
onready var range_finder := $RangeFinder/CollisionShape

func _set_up(range_distance):
    range_finder.shape.radius = range_distance
    fire_ray.cast_to = Vector2(range_distance, 0)
    fire_ray.add_exception(owner)


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
