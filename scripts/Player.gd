extends KinematicBody2D

class_name Player

const WALK_ACCELERATION := 0.05
const RUN_ACCELERATION := 0.10
const FRICTION := 0.075
const MAX_WALK_SPEED := 80
const MAX_RUN_SPEED := 120

var gravity: = 200
var jumpForce := 120
var jetUses := 1
var jetForce := jumpForce * 1.25
var canUseJet := false
var jetting := false

var jumping := false
var running := false

var velocity := Vector2.ZERO
var dir := 1

var canPick := true

export var picking := false
export var interecting := false
export var handPosition : Vector2

onready var jetParticles := $Jet/Particles2D
onready var jetNode := $Jet

onready var animationPlayer := $AnimationPlayer
onready var animationTree := $AnimationTree
onready var animationState = animationTree.get('parameters/playback')

onready var coyoteTimer := $CoyoteTimer


func _ready() -> void:
	animationTree.active = true

func _process(delta: float) -> void:
	input()

func _physics_process(delta) -> void:
	_animation()
	_player_movement(delta)
	GameEvents.handPosition = $Node2D/hand.global_position

func input() -> void:
	
	#direção de movimento do player
	dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# Correndo
	if Input.is_action_pressed("sprint"):
		running = true
	else:
		running = false
	
	# Pulando
	if Input.is_action_just_pressed("jump"):
		jumping = true
	else:
		jumping = false
	
	# interagir
	if Input.is_action_just_pressed("interact"):
		interecting = true
	else:
		interecting = false
	
	if Input.is_action_pressed("pickup"):
		picking = true
	else:
		picking = false
	
	#Save e Reaload
	if Input.is_action_just_pressed("Save"):
		GameEvents.save_game()

	if Input.is_action_just_pressed("Reload"):
		GameEvents.load_game()


func _player_movement(delta) -> void:
	
	if dir != 0:
		jetNode.scale.x = dir
		GameEvents.playerDir = dir
		
		if running:
			velocity.x = lerp(velocity.x, dir * MAX_RUN_SPEED, RUN_ACCELERATION)
		else:
			velocity.x = lerp(velocity.x, dir * MAX_WALK_SPEED, WALK_ACCELERATION)
			
		$Node2D.scale.x = dir
		
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION)
	
	velocity.y += gravity * delta
	
	# Verifica se pode usar o jato
	if canUseJet:
		if not is_on_floor() and coyoteTimer.is_stopped() and jumping:
			if jetUses > 0:
				jetUses -= 1
				velocity.y = - jetForce
				jetParticles.restart()
				jetting = true
				canUseJet = false
	
	#Verifica se pode pular
	if is_on_floor() or not coyoteTimer.is_stopped():
		jetUses = 1
		if jumping:
			coyoteTimer.stop()
			velocity.y = - jumpForce
			jetting = false
			canUseJet = true
		
	if coyoteTimer.is_stopped():
		canUseJet = true
	
	var wasOnFloor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if not is_on_floor() and wasOnFloor and not jumping:
		coyoteTimer.start()

func _animation() -> void:
	if dir != 0:
		animationTree.set('parameters/Idle/blend_position', dir)
		animationTree.set('parameters/Walk/blend_position', dir)
		animationTree.set('parameters/Run/blend_position', dir)
		animationTree.set('parameters/Jump/blend_position', dir)
		animationTree.set('parameters/JetFire/blend_position', dir)
		animationTree.set('parameters/JetUp/blend_position', dir)
		
		
		if running:
			animationState.travel('Run')
		else:
			animationState.travel('Walk')
			
		$Node2D.scale.x = dir
		
	else:
		animationState.travel('Idle')
	
	if not is_on_floor():
		if velocity.y < 0 and jetting:
			animationState.travel('JetUp')
		else:
			animationState.travel('Jump')

func die() -> void:
	get_tree().reload_current_scene()
