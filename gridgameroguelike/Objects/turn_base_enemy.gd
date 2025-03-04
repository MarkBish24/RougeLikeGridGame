extends Node2D

@onready var tile_map = $"../../TileMapLayer"
@onready var player = $"../Player"


var tile_positions_32 = []

const DIRECTIONS = [
	Vector2(0, -32),  # Up
	Vector2(0, 32),   # Down
	Vector2(-32, 0),  # Left
	Vector2(32, 0)    # Right
]

func set_enemy_position(pos:Vector2) -> void:
	self.position = pos

func _ready() -> void:
	tile_positions_32 = tile_map.get_tile_positions_32()
	
func move() -> void:
	var path = get_path_to_player()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", path[1], 0.2)
	pass

func get_path_to_player() -> Array:
	var start_position = self.position
	var end_position = player.get_future_position()
	
	if start_position == end_position:
		return [start_position, end_position]
	
	var open_set = [start_position]
	var came_from = {}
	var g_score = {start_position: 0}
	var f_score = {start_position: heuristic(start_position, end_position)}
	
	while open_set.size() > 0:
		open_set.sort_custom(func(a, b): return f_score.get(a, INF) < f_score.get(b, INF))
		var current = open_set.pop_front()
		
		if current == end_position:
			return reconstruct_path(came_from, current)
		
		for direction in DIRECTIONS:
			var neighbor = current + direction
			
			if not tile_map.is_tile_position(neighbor):
				continue
				
			var tentative_g_score = g_score[current] + 1
			if tentative_g_score < g_score.get(neighbor, INF):
				# Found a better path to this tile
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g_score
				f_score[neighbor] = g_score[neighbor] + heuristic(neighbor, end_position)

				if neighbor not in open_set:
					open_set.append(neighbor)

	return []  # No path found
				
	
func heuristic(a: Vector2, b:Vector2) -> int:
	return abs(a.x - b.x) + abs(a.y - b.y)
	
func reconstruct_path(came_from:Dictionary, current:Vector2) -> Array:
	var path = [current]
	while current in came_from:
		current = came_from[current]
		path.append(current)
	path.reverse()
	return path
	
