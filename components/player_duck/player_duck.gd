class_name PlayerDuck
extends CharacterBody2D

@export var speed = 400
@onready var camera = $Camera2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_input():
	var input_direction = Vector2.ZERO

	if Input.is_action_pressed("Right"):
		input_direction = Vector2(1, 0)
	elif Input.is_action_pressed("Left"):
		input_direction = Vector2(-1, 0)

	velocity = input_direction * speed

func _physics_process(delta):
	get_input()

	velocity.y += gravity * delta

	move_and_slide()
