extends TileMapLayer

var source_id = 0
signal tile_map_completed

const TILE_SIZE = 32
const DIRECTIONS = [
		Vector2i(1, 0),   # Right
		Vector2i(-1, 0),  # Left
		Vector2i(0, 1),   # Down
		Vector2i(0, -1)   # Up
]

func _ready():
	var start_position = Vector2i.ZERO
	generate_tiles(start_position, 30)
	
	await get_tree().process_frame
	tile_map_completed.emit()
	
	
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
