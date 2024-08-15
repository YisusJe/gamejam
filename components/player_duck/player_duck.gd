class_name PlayerDuck
extends CharacterBody2D

@export var speed = 200
@export var jumpVelocity = 200
@onready var camera = $Camera2D
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var step_cooldown = 0
var active: bool = false

func get_input(delta):
	if active:
		var direction = Input.get_axis('Left', 'Right')
		velocity.y += gravity * delta
		velocity.x = direction * speed

		if is_on_floor() and Input.is_action_just_pressed('Up'):
			velocity.y = -jumpVelocity
	else:
		velocity = Vector2.ZERO

func get_animation(delta):
	if active: 
		if velocity.x != 0:
			if step_cooldown <= 0 and is_on_floor():
				$AudioStreamPlayer.play()
				step_cooldown = 0.6
			anim.play('walk')
		else:
			anim.play('idle')

		step_cooldown = step_cooldown - delta
		sprite.flip_h = velocity.x < 0 if velocity.x != 0 else sprite.flip_h

func _physics_process(delta):
	get_input(delta)
	get_animation(delta)
	move_and_slide()

func set_active(is_active: bool):
	active = is_active
	if not active:
		$AudioStreamPlayer.stop()
