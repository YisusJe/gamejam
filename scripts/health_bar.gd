class_name HealthBar
extends ProgressBar

@export var player_controller : PlayerController

func _process(_delta):
	value = player_controller.player_submarine.health.health
