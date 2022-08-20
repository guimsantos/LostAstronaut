extends RigidBody2D

class_name Key

var picked = false

func _physics_process(delta: float) -> void:
	
	# lida com o
	if picked:
		self.position = get_node('../Player/Node2D/hand').global_position
		self.rotation_degrees = 0
		if GameEvents.playerDir == 1:
			self.scale.x = 1
			
		else:
			self.scale.x = -1
	
	
	if get_node('../Player').picking == true:
		var bodies = $AreaToGrab.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player" and get_node('../Player').canPick == true:
				picked = true
				get_node('../Player').canPick = false
				self.gravity_scale = 0
			if body.name == 'KeyGate':
				body.queue_free()
				self.queue_free()
	
	elif picked:
		picked = false
		get_node('../Player').canPick = true
		if get_node('../Player').velocity.y != 0:
			apply_impulse(Vector2(), Vector2(get_node('../Player').velocity.x, get_node('../Player').velocity.y))
		else:
			apply_impulse(Vector2(), Vector2(get_node('../Player').velocity.x, -5))
		self.gravity_scale = 1
