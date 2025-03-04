extends Node2D

@onready var left:Sprite2D = $Left
@onready var right:Sprite2D = $Right
@onready var up:Sprite2D = $Up
@onready var down:Sprite2D = $Down
@onready var future_position:Marker2D = $FuturePosition

var arrows:Array[Sprite2D] 

func _ready() -> void:
	arrows = [up, down, left, right] 
	hide_all_arrows()
	
func hide_all_arrows() -> void:
	for arrow in arrows:
		arrow.visible = false
		arrow.get_node("AnimationPlayer").pause()
		
func play_up_arrow() -> void:
	up.get_node("AnimationPlayer").play("Cycle")
	up.visible = true
	future_position.position = Vector2(0, -32)

func play_down_arrow() -> void:
	down.get_node("AnimationPlayer").play("Cycle")
	down.visible = true
	future_position.position = Vector2(0, 32)

func play_left_arrow() -> void:
	left.get_node("AnimationPlayer").play("Cycle")
	left.visible = true
	future_position.position = Vector2(-32, 0)

func play_right_arrow() -> void:
	right.get_node("AnimationPlayer").play("Cycle")
	right.visible = true
	future_position.position = Vector2(32, 0)

func get_future_position() -> Vector2:
	return future_position.position
	
func get_current_arrow_direction() -> Vector2:
	if up.visible:
		return Vector2(0, -32)
	elif down.visible:
		return Vector2(0, 32)
	elif left.visible:
		return Vector2(-32, 0)
	elif right.visible:
		return Vector2(32, 0)
	else:
		return Vector2.ZERO
