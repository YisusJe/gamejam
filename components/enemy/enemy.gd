extends CharacterBody2D

@export var player_submarine : PlayerSubmarine
@export var speed = 100
@onready var area = $Area2D

var is_illuminated = false

func _ready():
	area.monitoring = true
	area.connect("area_entered", on_light_entered)
	area.connect("area_exited", on_light_exited)

func _physics_process(_delta):
	var raw_velocity = position.direction_to(player_submarine.position) * speed
	velocity = -raw_velocity if is_illuminated else raw_velocity # Move in opposite direction if illuminated

	move_and_slide()

func on_light_entered(_area):
	is_illuminated = true
	pass

func on_light_exited(_area):
	is_illuminated = false
	pass
