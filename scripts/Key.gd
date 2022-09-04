extends RigidBody2D

class_name Key

var picked = false

func _physics_process(delta: float) -> void:
	
	# lida com o
	if picked:
		self.position = $"%Player/Node2D/hand".global_position
		self.rotation_degrees = 0
		if GameEvents.playerDir == 1:
			self.scale.x = 1
			
		else:
			self.scale.x = -1
	
	
	if $'%Player'.picking == true:
		var bodies = $AreaToGrab.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player" and $'%Player'.canPick == true:
				picked = true
				$'%Player'.canPick = false
				self.gravity_scale = 0
			if body.name == 'KeyGate':
				body.queue_free()
				self.queue_free()
	
	elif picked:
		picked = false
		$'%Player'.canPick = true
		if $'%Player'.velocity.y != 0:
			apply_impulse(Vector2(), Vector2($'%Player'.velocity.x, $'%Player'.velocity.y))
		else:
			apply_impulse(Vector2(), Vector2($'%Player'.velocity.x, -5))
		self.gravity_scale = 1
