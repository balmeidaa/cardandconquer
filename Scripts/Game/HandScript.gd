extends Node2D


var card_count = 0
var cards_in_hand = 0
var spread_curve = preload("res://Assets/resources/spread_curve.tres") as Curve
var height_curve = preload("res://Assets/resources/height_curve.tres") as Curve

export var card_spread : int = 250

 
func _process(_delta):
    fan_cards()

        
func fan_cards():
    
    cards_in_hand = get_children()
    
    if card_count == cards_in_hand.size():
        return

    card_count = cards_in_hand.size()
    var hand_ratio = 0.5

    if card_count > 1:
        for card in cards_in_hand:
            hand_ratio = float(card.get_index()) / float(card_count - 1)
            var position = self.global_transform
            position.origin.x += spread_curve.interpolate(hand_ratio) * card_spread
            position.origin.y -= height_curve.interpolate(hand_ratio) * card_spread/3
            card.global_transform = position

