extends StaticBody2D
class_name StructureToken


onready var building_sprite = $HexagonalBG/Building
var type = null
var generic_building = ["res://Tokens/TokenImage/modern-city.png",
                       "res://Tokens/TokenImage/shop.png",
                     "res://Tokens/TokenImage/house.png",
                    "res://Tokens/TokenImage/damaged-house.png"]

var bunker_destroyed_img = "res://Tokens/TokenImage/bunker destroyed.png" 
export var bunker_hitpoints = 300

# Called when the node enters the scene tree for the first time.
func set_up():
    match type:
        "flag":
            $HexagonalBG/Tower.show()
        "bunker":
            $HexagonalBG/Bunker.show()
        _:
            $HexagonalBG/Building.show()
            var rng = RandomNumberGenerator.new()
            rng.randomize() 
            # set up a generic building texture
            var generic_texture = rng.randi_range(0, generic_building.size() - 1 )
            building_sprite.texture = load(generic_building[generic_texture])


func _ready():
    #type = "bunker"
    set_up()
