extends Node2D

signal player_direction(direction:int)

func set_player_position(pos:Vector2) -> void:
	self.position = pos
	
func get_player_position() -> Vector2:
	return self.position
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_right"):
		player_direction.emit(0)
	if Input.is_action_just_pressed("move_left"):
		player_direction.emit(1)
	if Input.is_action_just_pressed("move_down"):
		player_direction.emit(2)
	if Input.is_action_just_pressed("move_up"):
		player_direction.emit(3)
		
func move_player(pos:Vector2):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", pos, 0.15)
