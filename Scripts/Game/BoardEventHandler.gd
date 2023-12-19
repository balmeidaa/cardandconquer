extends Node


signal unit_info
signal cell_clicked


func cell_clicked(pixel_coord: Vector2):
    emit_signal("cell_clicked", pixel_coord)

func unit_info(unit):
    emit_signal("unit_info", unit)
