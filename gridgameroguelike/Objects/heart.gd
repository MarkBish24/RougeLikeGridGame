extends TextureRect
class_name Heart

signal deleted(pos:Vector2)

func delete() -> void:
	$AnimationPlayer.play("Damage")
	$Timer.start()

func _on_timer_timeout() -> void:
	deleted.emit(self.position)
	self.queue_free()
	pass
