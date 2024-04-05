extends Node

signal unit_info
signal cell_clicked

var root
var bullet_vfx = preload("res://VFX/bulletsVFX.tscn")
var cannon_vfx = preload("res://VFX/cannonVFX.tscn")
var missile_vfx = preload("res://VFX/MissileVFX.tscn")

var cannon_muzzle = preload("res://VFX/MuzzleCannon.tscn")
var bullets_muzzle = preload("res://VFX/MuzzleBullets.tscn")

#var missile_vfx = preload()

func cell_clicked(pixel_coord: Vector2):
    emit_signal("cell_clicked", pixel_coord)
    
func unit_info(unit):
    emit_signal("unit_info", unit)

func set_root(game_root):
    root = game_root
