extends Node2D


export(String, FILE, "*.png") var img_file
export(String, FILE, "*.png") var background_img_file

export var card_title: String
export var card_cost: int
export var description: String

export var card_effect: String  

enum CardType {
    SUPPORT,
    TACTICAL
   }

export (CardType) var card_type = CardType.SUPPORT

onready var card_title_label = $CardTitle
onready var card_cost_label = $CardCost
onready var description_label = $Description

var play_effect := ''
#agregar objectivo


func set_up_card(card_attr:Dictionary):
    play_effect = card_attr['play_effect']
    card_title_label.text = card_attr['card_title']
    card_cost = card_attr['card_cost']
    card_cost_label.text = String(card_attr['card_cost'])
    description_label.text = card_attr['description']
    # cargar imagenes
    
"""
card_effect is the callable function
args {
    player: player that uses the card played,
    selected_unit: friendly unit selected,
    target_unit: enemy units
    area: array of position to effect,
    
   }
"""
func play_card(card_args:Dictionary):
    #callable play effect
    pass
