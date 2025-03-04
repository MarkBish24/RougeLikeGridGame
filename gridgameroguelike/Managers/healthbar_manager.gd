extends CanvasLayer

@export var health : int
@export var heart_scene: PackedScene
@export var hit_particle: PackedScene
@onready var heart_container:HBoxContainer = $MarginContainer/HeartContainer

var health_array = [Heart]

func _ready() -> void:
	for i in range(health):  # Loop correctly over an integer
		add_health()

func add_health() -> void:
	var heart_instance = heart_scene.instantiate()
	health_array.append(heart_instance)
	heart_container.add_child(heart_instance)
	heart_instance.deleted.connect(on_deleted)

func remove_health() -> void:
	if health_array.size() > 0: 
		var last_heart = health_array.pop_back()
		last_heart.delete()
	pass
	
func on_deleted(pos:Vector2) -> void:
	var hit_particle_instance = hit_particle.instantiate()
	$ParticleContainer.add_child(hit_particle_instance)
	hit_particle_instance.position = pos + Vector2(96,48)
	
