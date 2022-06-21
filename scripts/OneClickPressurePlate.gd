extends StaticBody2D

onready var sprite := get_node("Sprite")
onready var area := get_node("Area2D")
export (Array, NodePath) onready var gates

func _ready() -> void:
	for i in gates.size():
		gates[i] = get_node(gates[i]) as PressureGate

func _on_Area2D_body_entered(_body : Node) -> void:
	sprite.frame = 1
	area.queue_free()
	for gate in gates:
		gate.free()
