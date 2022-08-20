tool
extends Node2D

export (bool) onready var onCeiling
export (bool) var clickToUpdate setget updateTexture;

func updateTexture(p_update):
	if Engine.editor_hint and p_update :
		_change_rotation()
		clickToUpdate = false

func _ready() -> void:
	_change_rotation()


func _change_rotation() -> void:
	if onCeiling:
		rotation_degrees = 180
	else:
		rotation_degrees = 0


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		if onCeiling:
			if body.global_position.y > $Area2D/CollisionShape2D.global_position.y + 3:
				print('morreu ala kkkkk') #enviar sinal pro player q morreu
			else:
				print('slk o cara é preparado')

		else:
			if body.global_position.y < $Area2D/CollisionShape2D.global_position.y:
				print('morreu ala kkkkk') #enviar sinal pro player q morreu
			else:
				print('slk o cara é preparado')
