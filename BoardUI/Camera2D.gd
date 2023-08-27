extends Camera2D



func _process(delta):
   if Input.is_action_pressed("ui_up"):
        position.y -= delta * 220
   if Input.is_action_pressed("ui_down"):
       position.y += delta * 220
   if Input.is_action_pressed("ui_left"):
       position.x -= delta * 220
   if Input.is_action_pressed("ui_right"):
       position.x += delta * 220
      
