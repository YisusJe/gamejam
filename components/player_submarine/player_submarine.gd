class_name PlayerSubmarine
extends CharacterBody2D

@export var max_steering = 0.3
@export var auto_breaking_force = 0.2
@export var speed = 400
@export var health : Health;
@export var flashlightDuration = 5.0
@export var isFlashlightBroke = false
@onready var camera = $Camera2D
@onready var submarine_flashlight = $PlayerSubmarineContainer/SubmarineFlashlight
@onready var burbujas = $PlayerSubmarineContainer/Burbuja
@onready var container = $PlayerSubmarineContainer
signal flashlight_broke
var stering = Vector2.ZERO

func get_input(delta):
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down") / (10000 * delta)
	stering += input_direction
	stering = stering.lerp(Vector2.ZERO, auto_breaking_force * delta)
	stering = stering.limit_length(max_steering)

	velocity = stering * speed

	burbujas.amount_ratio = stering.length() / max_steering

	if(stering.length() > max_steering * 0.7):
		burbujas.amount_ratio = 1.0
	elif(stering.length() > max_steering * 0.4):
		burbujas.amount_ratio = 0.5
	else:
		burbujas.amount_ratio = 0.1

	if velocity.x > 0:
		container.scale.x = abs(container.scale.x)
	elif velocity.x < 0:
		container.scale.x = abs(container.scale.x) * -1

	if(Input.is_action_pressed("Flashlight")):
		submarine_flashlight.turn_on(delta)
		flashlightDuration -= 1 * delta
		if (flashlightDuration <= 0):
			submarine_flashlight.turn_off()
			if (!isFlashlightBroke):
				flashlight_broke.emit()
				isFlashlightBroke = true
			return
	else:
		submarine_flashlight.turn_off()


func _physics_process(delta):
	get_input(delta)
	move_and_slide()
