extends Node

@onready var tile_map:TileMapLayer = $"../TileMapLayer"
@onready var finish_flag:Node2D = $FinishFlag
@onready var player: Node2D = $Player
@onready var camera: Node2D = $"../Camera2D"

@export var turn_base_enemy: PackedScene 
@export var rock: PackedScene
@export var time_base_enemy: PackedScene

var tb_enemy_array = []
var rock_array = []
var time_enemy_array = []

const DIRECTIONS = [
	Vector2(0, -32),  # Up
	Vector2(0, 32),   # Down
	Vector2(-32, 0),  # Left
	Vector2(32, 0)    # Right
]


func _ready() -> void:
	player.player_direction.connect(on_player_direction)
	player.player_moved.connect(on_player_moved)


func create_enemies():
	for i in range(3):
		var turn_base_enemy_instance = turn_base_enemy.instantiate()
		tb_enemy_array.append(turn_base_enemy_instance)
		add_child(turn_base_enemy_instance)
		turn_base_enemy_instance.set_enemy_position(tile_map.get_random_tile_position())
	for i in range(6):
		var rock_instance = rock.instantiate()
		rock_array.append(rock_instance)
		add_child(rock_instance)
	for i in range(3):
		var time_base_enemy_instance = time_base_enemy.instantiate()
		time_enemy_array.append(time_base_enemy_instance)
		add_child(time_base_enemy_instance)
		
		
func move_all_turn_based_enemies():
	for enemy in tb_enemy_array:
		enemy.move()
	
#Once the Tile map is completed it will set the player and finish flag positions
func set_object_positions():
	player.set_player_position(tile_map.get_random_tile_position())
	finish_flag.set_flag_position(tile_map.get_farthest_tile_position(player.get_player_position()))
	create_enemies()
	
#Movement of the Player
func on_player_direction(direction: int):
	var pos = player.get_player_position() + DIRECTIONS[direction] #the position the player will go
	var current_direction = player.get_current_direction() #the direction of the highlighted arrow on the character
	
	if tile_map.is_tile_position(pos): #Checks if the tile exists, if it does it moves to the tile
		if current_direction == DIRECTIONS[direction]: #Checks to see if the highlighted direction of the character is the same as the keybind WASD
			player.move_player(pos)
			if not tile_map.is_tile_position(pos + DIRECTIONS[direction]): #Unhighlights the arrow if it runs into a wall
				player.get_node('ArrowManager').hide_all_arrows()
				print("Hit Wall")
	else:
		camera.shake_camera()
		player.get_node('ArrowManager').hide_all_arrows()

func on_player_moved():
	move_all_turn_based_enemies()
