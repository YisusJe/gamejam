class_name PlayerSubmarine
extends CharacterBody2D

@export var max_steering = 0.3
@export var auto_breaking_force = 0.2
@export var speed = 400
@onready var camera = $Camera2D
@onready var submarine_flashlight = $SubmarineFlashlight

var stering = Vector2.ZERO

func get_input(delta):
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down") / (10000 * delta)
	stering += input_direction
	stering = stering.lerp(Vector2.ZERO, auto_breaking_force * delta)
	stering = stering.limit_length(max_steering)

	velocity = stering * speed

	if(Input.is_action_pressed("Flashlight")):
		submarine_flashlight.turn_on()
	else:
		submarine_flashlight.turn_off()

func _physics_process(delta):
	get_input(delta)
	move_and_slide()
