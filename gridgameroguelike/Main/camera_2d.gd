extends Camera2D

var shake_intensity: float = 5.0
var shake_duration: float = 0.2

var shake_time = 0.0
var shake_offset = Vector2.ZERO

@onready var player = $"../ObjectManager/Player"

func _process(delta: float) -> void:
	var target_position = player.get_player_position()
	self.position = self.position.lerp(target_position, 0.15) + shake_offset
	if shake_time > 0:
		shake_time -= delta
		shake_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		shake_offset = Vector2.ZERO  # Reset shake after duration
	
func shake_camera() -> void:
	shake_time = shake_duration
