class_name PlayerSubmarine
extends CharacterBody2D

@export var speed = 400
@onready var camera = $Camera2D

func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()