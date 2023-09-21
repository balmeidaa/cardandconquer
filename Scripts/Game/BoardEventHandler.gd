extends Node

signal cell_clicked


func cell_clicked(pixel_coord: Vector2):
    emit_signal("cell_clicked", pixel_coord)
