extends Node2D

@onready var tile_map: TileMapLayer = $TileMapLayer
@onready var object_manager: Node = $ObjectManager

func _ready() -> void:
	tile_map.tile_map_completed.connect(on_tile_map_completed)
	
func on_tile_map_completed():
	object_manager.set_object_positions()
	pass
