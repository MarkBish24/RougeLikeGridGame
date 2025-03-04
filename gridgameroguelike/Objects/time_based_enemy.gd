extends Node2D

@onready var tile_map = $"../../TileMapLayer"
@onready var player = $"../Player"
@onready var timer = $Timer
var tile_positions_32 = []

const ENEMY_DIRECTIONS = [
	Vector2(-32, -32),  # Up
	Vector2(32, 32),   # Down
	Vector2(-32, 32),  # Left
	Vector2(32, -32)    # Right
] 

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
	set_enemy_position(tile_map.get_random_tile_position())
	timer.start()
	
func move() -> void:
	var path = get_path_to_player()
	if path.size() < 2:
		return
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", path[1], 0.2)
	tween.finished.connect(_on_tween_finished)
	
func _on_tween_finished() -> void:
	timer.start()
	
func get_path_to_player():
	var start_position = self.position
	var end_position = player.get_player_position()
	
	if start_position.distance_to(end_position) < 70:
		attack(end_position)
		return []
		
	var open_set = [start_position]
	var came_from = {}
	var g_score = {start_position: 0}
	var f_score = {start_position: heuristic(start_position, end_position)}
	
	while open_set.size() > 0:
		open_set.sort_custom(func(a, b): return f_score.get(a, INF) < f_score.get(b, INF))
		var current = open_set.pop_front()
		
		if current.distance_to(end_position) < 70:
			return reconstruct_path(came_from, current)
		
		for direction in ENEMY_DIRECTIONS:
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

	return []
	
func attack(to_position:Vector2) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", to_position, 0.2)
	tween.finished.connect(_on_attack_finished)
	pass
	
func _on_attack_finished() -> void:
	timer.start()
	
func heuristic(a: Vector2, b:Vector2) -> int:
	return abs(a.x - b.x) + abs(a.y - b.y)

func reconstruct_path(came_from:Dictionary, current:Vector2) -> Array:
	var path = [current]
	while current in came_from:
		current = came_from[current]
		path.append(current)
	path.reverse()
	return path

func _on_timer_timeout() -> void:
	move()
