extends Node2D

var entered := false


onready var player := get_node("%Player") as Player
onready var collision := get_node("Area2D/CollisionShape2D")
onready var mapNode = get_parent().get_parent() # access Map node


func _process(delta: float) -> void:
	if entered:
		if player.interecting:
			$AnimationPlayer.play("CheckPoint")
			collision.disabled = true
			GameEvents.playerLastPosition = self.position
			pass
			
			

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == 'Player':
		entered = true


func _on_Area2D_body_exited(body: Node) -> void:
	if body.name == 'Player':
		entered = false
