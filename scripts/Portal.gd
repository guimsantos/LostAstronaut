extends Node2D

class_name Teleport_Portal

export (NodePath) onready var connectedPortal = get_node(connectedPortal) as Teleport_Portal
export (String, 'Right', 'Left') var teleportTo := 'Right'

onready var rPosition = $RightPosition.global_position
onready var lPosition = $LeftPosition.global_position

onready var playerNode = get_node('../../Player') as Player

var entered := false
var interact := false


func _physics_process(delta: float) -> void:
	
	if playerNode.interecting == true:
		interact = true
	else:
		interact = false
	
	if interact and entered:
		if connectedPortal.teleportTo == 'Right':
			playerNode.position = connectedPortal.rPosition
		elif connectedPortal.teleportTo == 'Left':
			playerNode.position = connectedPortal.lPosition

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == 'Player':
		entered = true

func _on_Area2D_body_exited(body: Node) -> void:
	if body.name == 'Player':
		entered = false
