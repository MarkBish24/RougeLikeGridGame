extends Node2D

@onready var tile_map: TileMapLayer = $TileMapLayer

func _ready() -> void:
	tile_map.tile_map_completed.connect(on_tile_map_completed)
	
func on_tile_map_completed():
	pass
