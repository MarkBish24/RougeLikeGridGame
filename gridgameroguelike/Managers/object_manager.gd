extends Node

@onready var tile_map:TileMapLayer = $"../TileMapLayer"
@onready var finish_flag:Node2D = $FinishFlag
@onready var player: Node2D = $Player
@onready var camera: Node2D = $"../Camera2D"

const DIRECTIONS = [
	Vector2(0, -32),  # Up
	Vector2(0, 32),   # Down
	Vector2(-32, 0),  # Left
	Vector2(32, 0)    # Right
]


func _ready() -> void:
	player.player_direction.connect(on_player_direction)


func create_enemies():
	pass
	
func set_object_positions():
	player.set_player_position(tile_map.get_random_tile_position())
	finish_flag.set_flag_position(tile_map.get_farthest_tile_position(player.get_player_position()))
	pass
	
func on_player_direction(direction: int):
	var pos = player.get_player_position() + DIRECTIONS[direction]
	if tile_map.is_tile_position(pos):
		player.move_player(pos)
	else:
		camera.shake_camera()
	if tile_map.is_tile_position(player.get_future_position()) == false:
		player.get_node('ArrowManager').hide_all_arrows()
	
