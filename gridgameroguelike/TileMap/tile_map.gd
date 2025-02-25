extends TileMapLayer

var source_id = 0
signal tile_map_completed

const TILE_SIZE = 32
const DIRECTIONS_32 = [
		Vector2(32, 0),   # Right
		Vector2(-32, 0),  # Left
		Vector2(0, 32),   # Down
		Vector2(0, -32)   # Up
]
const DIRECTIONS = [
		Vector2i(1, 0),   # Right
		Vector2i(-1, 0),  # Left
		Vector2i(0, 1),   # Down
		Vector2i(0, -1)   # Up
]

#tileMap in tile syntax
var tile_positions = []
#tile map in position length of tile
var tile_positions_32 = []

func _ready():
	var start_position = Vector2i.ZERO
	generate_tiles(start_position, 30)
	
	await get_tree().process_frame
	set_tile_positions()
	tile_map_completed.emit()
	
func set_tile_positions():
	tile_positions = get_used_cells()
	for tile in tile_positions:
		tile_positions_32.append(convert_tile_position_to_position(tile))
	
func generate_tiles(start_position, count):
	var queue = [start_position, 
				start_position + DIRECTIONS[0],
				start_position + DIRECTIONS[1],
				start_position + DIRECTIONS[2],
				start_position + DIRECTIONS[3],]
	
	while count > 0:
		for i in range(queue.size()):
			var pos = queue.pop_front()
			
			if get_cell_source_id(pos) != -1:
				continue
				
			set_cell(pos, source_id, Vector2i.ZERO)
			
			var shuffled_directions = DIRECTIONS.duplicate()
			shuffled_directions.shuffle()
			
			var added_tile = false
				
			for direction in shuffled_directions:
				var new_pos = pos + direction
				if randf() < .35 or not added_tile:
					queue.append(new_pos)
					added_tile = true
				
		count -= 1
		
func convert_position_to_tile_position(world_position: Vector2) -> Vector2i:
	# Convert world position to tile position by dividing by TILE_SIZE
	return Vector2i(world_position / TILE_SIZE)

func convert_tile_position_to_position(tile_position: Vector2i) -> Vector2:
	# Convert tile position to world position by multiplying by TILE_SIZE
	# and centering it
	return (tile_position * TILE_SIZE) + Vector2i(TILE_SIZE / 2, TILE_SIZE / 2)
	
func is_tile_position(pos:Vector2) -> bool:
	return tile_positions_32.has(pos)

func get_random_tile_position() -> Vector2:
	if tile_positions.is_empty():
		return Vector2.ZERO  # Return a default position if no tiles exist
	
	var random_tile = tile_positions[randi() % tile_positions.size()]
	return convert_tile_position_to_position(random_tile)
	
func get_farthest_tile_position(start_tile: Vector2):
	#BFS set up
	var queue = [start_tile]
	var visited = {}
	visited[start_tile] = true
	var farthest_tile = start_tile
	
	while queue.size() > 0:
		var current_tile = queue.pop_front()
		farthest_tile = current_tile
		
		for direction in DIRECTIONS_32:
			var next_tile = current_tile + (direction)
			if next_tile in tile_positions_32 and not visited.has(next_tile):
				visited[next_tile] = true
				queue.append(next_tile)
			 
	return farthest_tile
	
