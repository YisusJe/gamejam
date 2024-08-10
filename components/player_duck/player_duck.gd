class_name PlayerDuck
extends CharacterBody2D

@export var speed = 300
@export var jumpVelocity = 500
@onready var camera = $Camera2D
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_input(delta):
	var direction = Input.get_axis('Left', 'Right')
	velocity.y += gravity * delta
	velocity.x = direction * speed

	if is_on_floor() and Input.is_action_just_pressed('Up'):
		velocity.y = -jumpVelocity

func get_animation():
	if velocity.x != 0:
		anim.play('walk')
	else:
		anim.play('idle')
	
	sprite.flip_h = velocity.x < 0 if velocity.x != 0 else sprite.flip_h

func _physics_process(delta):
	get_input(delta)
	get_animation()
	move_and_slide()
