class_name SubmarineInside
extends Node2D

@export var player_submarine : PlayerSubmarine
@export var player_controller : PlayerController
@export var tries_to_repair = 8
@onready var light_repair = $LightRepair
@onready var label = $LightRepair/CollisionShape2D/Label
@onready var progressBar = $ProgressBar
var can_interact = false
var can_repair = false
var default_repair_times = tries_to_repair
# Called when the node enters the scene tree for the first time.
func _ready():
	print('a ', player_controller)
	player_submarine.connect('flashlight_broke', on_flashlight_broke)
	progressBar.hide()
	progressBar.max_value = default_repair_times
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass

func on_flashlight_broke():
	light_repair.on_flashlight_broke()
	progressBar.show()
	can_interact = true

func _input(event):
	if event.is_action_pressed('interact') && can_interact && can_repair:
		if (tries_to_repair > 1):
			tries_to_repair -= 1
			progressBar.value +=  1
			return
		tries_to_repair = default_repair_times
		progressBar.value = 0
		player_submarine.flashlightDuration = 5.0
		player_submarine.isFlashlightBroke = false
		can_interact = false
		can_repair = false
		label.hide()
		progressBar.hide()

func _on_light_repair_body_entered(body):
	if (body.name == 'PlayerDuck'):
		can_repair = true

func _on_light_repair_body_exited(body):
	if (body.name == 'PlayerDuck'):
		can_repair = false

func _on_timon_area_2d_body_entered(body):
	if (body.name == 'PlayerDuck'):
		player_controller.set_can_change_character(true)

func _on_timon_area_2d_body_exited(body):
	if (body.name == 'PlayerDuck'):
		player_controller.set_can_change_character(false)

