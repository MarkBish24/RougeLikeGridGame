extends CPUParticles2D

func _ready() -> void:
	self.emitting = true
	$Timer.start()

func _on_timer_timeout() -> void:
	self.queue_free()
