extends KinematicBody2D

class_name Player

const WALK_ACCELERATION := 0.05
const RUN_ACCELERATION := 0.10
const FRICTION := 0.075
const MAX_WALK_SPEED := 80
const MAX_RUN_SPEED := 120

var gravity: = 200
var jumpForce := 150
var jetUses := 1
var jetForce := jumpForce + 50

var jumping := false
var running := false
var jeting := false

var velocity := Vector2.ZERO
var dir := 1

var canPick := true

export var interecting := false
export var handPosition : Vector2


onready var jetParticles := $Jet/Particles2D
onready var jetNode := $Jet

onready var animationPlayer := $AnimationPlayer
onready var animationTree := $AnimationTree
onready var animationState = animationTree.get('parameters/playback')


func _ready() -> void:
	animationTree.active = true


func _process(delta: float) -> void:
	input()


func _physics_process(delta) -> void:
	
	_animation()
	_player_movement(delta)
	GameEvents.handPosition = $Node2D/hand.global_position

func input() -> void:
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
	if Input.is_action_pressed("interact"):
		interecting = true
	else:
		interecting = false

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
	
	if is_on_floor():
		jetUses = 1
		jeting = false
		if jumping:
			velocity.y = - jumpForce
	
	# Verifica se pode usar o jato
	if not is_on_floor():
		if jetUses > 0 and jumping:
			jetUses -= 1
			velocity.y = - jetForce
			jetParticles.restart()
			jeting = true
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _animation() -> void:
	if dir != 0:
		animationTree.set('parameters/Idle/blend_position', dir)
		animationTree.set('parameters/Walk/blend_position', dir)
		animationTree.set('parameters/Run/blend_position', dir)
		animationTree.set('parameters/Jump/blend_position', dir)
		animationTree.set('parameters/JetFire/blend_position', dir)
		animationTree.set('parameters/JetUp/blend_position', dir)
		animationTree.set('parameters/Die/blend_position', dir)
		
		if running:
			animationState.travel('Run')
		else:
			animationState.travel('Walk')
			
		$Node2D.scale.x = dir
		
	else:
		animationState.travel('Idle')
	
	if not is_on_floor():
		if velocity.y < 0 and jeting:
			animationState.travel('JetUp')
		else:
			animationState.travel('Jump')
