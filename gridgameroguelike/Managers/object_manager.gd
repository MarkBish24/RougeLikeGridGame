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
	
#Once the Tile map is completed it will set the player and finish flag positions
func set_object_positions():
	player.set_player_position(tile_map.get_random_tile_position())
	finish_flag.set_flag_position(tile_map.get_farthest_tile_position(player.get_player_position()))
	pass
	
#Movement of the Player
func on_player_direction(direction: int):
	var pos = player.get_player_position() + DIRECTIONS[direction] #the position the player will go
	var current_direction = player.get_current_direction() #the direction of the highlighted arrow on the character
	
	if tile_map.is_tile_position(pos): #Checks if the tile exists, if it does it moves to the tile
		if current_direction == DIRECTIONS[direction]: #Checks to see if the highlighted direction of the character is the same as the keybind WASD
			player.move_player(pos)
			if tile_map.is_tile_position(pos + DIRECTIONS[direction]) == false: #Unhighlights the arrow if it runs into a wall
				player.get_node('ArrowManager').hide_all_arrows()
				print("Hit Wall")
	else:
		camera.shake_camera()

	
