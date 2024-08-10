class_name PlayerSubmarine
extends CharacterBody2D

@export var speed = 400
@onready var camera = $Camera2D
@onready var submarine_flashlight = $SubmarineFlashlight

func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed

	if(Input.is_action_pressed("Flashlight")):
		submarine_flashlight.turn_on()
	else:
		submarine_flashlight.turn_off()

func _physics_process(_delta):
	get_input()
	move_and_slide()
