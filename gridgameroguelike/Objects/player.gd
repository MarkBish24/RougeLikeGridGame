extends Node2D

signal player_direction(direction:int)

@onready var arrow_manager:Node2D = $ArrowManager

func set_player_position(pos:Vector2) -> void:
	self.position = pos
	
func get_player_position() -> Vector2:
	return self.position
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		player_direction.emit(0)
		arrow_manager.hide_all_arrows()
		arrow_manager.play_up_arrow()
	if Input.is_action_just_pressed("move_down"):
		player_direction.emit(1)
		arrow_manager.hide_all_arrows()
		arrow_manager.play_down_arrow()
	if Input.is_action_just_pressed("move_left"):
		player_direction.emit(2)
		arrow_manager.hide_all_arrows()
		arrow_manager.play_left_arrow()
	if Input.is_action_just_pressed("move_right"):
		player_direction.emit(3)
		arrow_manager.hide_all_arrows()
		arrow_manager.play_right_arrow()

func move_player(pos:Vector2):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", pos, 0.15)
	
func get_future_position() -> Vector2:
	return arrow_manager.get_future_position()
