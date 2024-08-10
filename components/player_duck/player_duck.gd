class_name PlayerDuck
extends CharacterBody2D

@export var speed = 300
@export var jumpVelocity = 500
@onready var camera = $Camera2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_input(delta):
	var direction = Input.get_axis('Left', 'Right')
	velocity.y += gravity * delta
	velocity.x = direction * speed

	if is_on_floor() and Input.is_action_just_pressed('Up'):
		velocity.y = -jumpVelocity
		
func _physics_process(delta):
	get_input(delta)

	move_and_slide()
