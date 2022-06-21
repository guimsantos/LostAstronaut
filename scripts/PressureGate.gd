extends StaticBody2D

class_name PressureGate

onready var sprite := get_node("Sprite")
onready var collisionShape := get_node("CollisionShape2D")


func open() -> void:
	collisionShape.disabled = true
	sprite.hide()


func close() -> void:
	collisionShape.disabled = false
	sprite.show()
	
func perma_open() -> void:
	self.queue_free()
