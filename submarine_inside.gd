class_name SubmarineInside
extends Node2D

@export var player_submarine : PlayerSubmarine
@onready var light_repair = $LightRepair
@onready var label = $LightRepair/CollisionShape2D/Label
var can_interact = false
var can_repair = false
# Called when the node enters the scene tree for the first time.
func _ready():
	player_submarine.connect('flashlight_broke', on_flashlight_broke)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass

func on_flashlight_broke():
	light_repair.on_flashlight_broke()
	can_interact = true

func _input(event):
	if event.is_action_pressed('interact') && can_interact && can_repair:
		player_submarine.flashlightDuration = 5.0
		player_submarine.isFlashlightBroke = false
		can_interact = false
		can_repair = false
		label.hide()

func _on_light_repair_body_entered(body):
	if (body.name == 'PlayerDuck'):
		can_repair = true

func _on_light_repair_body_exited(body):
	if (body.name == 'PlayerDuck'):
		can_repair = false
