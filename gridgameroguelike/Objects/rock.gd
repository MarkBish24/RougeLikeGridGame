extends Node2D

@export var left_position: Vector2
@export var right_position: Vector2

@onready var wait_timer: Timer = $WaitTimer
@onready var shake_timer: Timer = $ShakeTimer
@onready var rock_particles: CPUParticles2D = $RockParticles
@onready var rock_sprite: Sprite2D = $Sprite2D
@onready var tile_map_layer:TileMapLayer = $"../../TileMapLayer"

const DIRECTIONS = [
	Vector2(0, -32),  # Up
	Vector2(0, 32),   # Down
	Vector2(-32, 0),  # Left
	Vector2(32, 0)    # Right
]

var tile_positions_32 = []

var distance: float
var slide_time: float
var is_sliding: bool = false

var shake_time = 0.0
var shake_offset = Vector2.ZERO

func _ready() -> void:
	tile_positions_32 = tile_map_layer.get_tile_positions_32()
	set_left_right_position(tile_map_layer.get_random_tile_position())
	

func _process(delta: float) -> void:
	var target_position = Vector2.ZERO
	rock_sprite.position = target_position + shake_offset
	if shake_time > 0:
		shake_time -= delta
		shake_offset = Vector2(randf_range(-1.5,1.5),randf_range(-1.5,1.5))
	else:
		shake_offset = Vector2.ZERO

func set_left_right_position(pos:Vector2):
	var direction = DIRECTIONS[randi() % DIRECTIONS.size()]
	left_position = pos
	while tile_map_layer.is_tile_position(left_position + direction):
		left_position += direction
	
	direction *= -1
	right_position = pos
	while tile_map_layer.is_tile_position(right_position + direction):
		right_position += direction
		
	if left_position == right_position:
		set_left_right_position(pos)
		return
		
	slide_time = left_position.distance_to(right_position) * .0035
		
	self.position = left_position
	
	slide()
	
func get_left_right_positions() -> Array[Vector2]:
	return [left_position, right_position]

func slide() -> void:
	if is_sliding:
		return  # Avoid starting a new slide if one is already in progress
	
	is_sliding = true  # Set flag to true when the slide starts
	rock_particles.emitting = true
	var tween = get_tree().create_tween()  # Create a Tween instance
	var target_position = right_position if self.position == left_position else left_position
	
	tween.tween_property(self, "position", target_position, slide_time)
	await tween.finished
	
	rock_particles.emitting = false
	is_sliding = false  # Reset the flag when the slide finishes
	shake_time = 0
	shake_timer.start()
	wait_timer.start()
	
	
func _on_wait_timer_timeout() -> void:
	slide()

func _on_shake_timer_timeout() -> void:
	shake_time = 1
