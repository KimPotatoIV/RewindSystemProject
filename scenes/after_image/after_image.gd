extends Node2D

##################################################
var lifetime: float = 1.0
var timer: float = 0.0

##################################################
func _ready() -> void:
	modulate.a = 0.5

##################################################
func _process(delta: float) -> void:
	timer += delta
	modulate.a = lerpf(0.7, 0.0, timer / lifetime)
	
	if timer >= lifetime:
		queue_free()
