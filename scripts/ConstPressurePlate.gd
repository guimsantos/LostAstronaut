extends StaticBody2D

onready var sprite = get_node("Sprite")
export (Array, NodePath) onready var gates


func _ready():
	for i in gates.size():
		gates[i-1] = get_node(gates[i-1]) as PressureGate


func _physics_process(delta: float) -> void:
	
	var bodies : Array = $Area2D.get_overlapping_bodies()
	
	if bodies.size() > 0:
		sprite.frame = 3
		for gate in gates:
			gate.open()
	elif bodies.size() == 0:
		sprite.frame = 2
		for gate in gates:
			gate.close()
		

