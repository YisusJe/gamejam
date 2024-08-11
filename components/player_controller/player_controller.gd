class_name PlayerController
extends Node

enum PlayerTypes {
	SUBMARINE,
	DUCK
}

@onready var background_theme = $"../AudioStreamPlayer"
@export var current_player_type : PlayerTypes = PlayerTypes.DUCK;
@export var player_submarine : PlayerSubmarine;
@export var player_duck : PlayerDuck;

var current_player;
const speed_active = 400
const speed_inactive = 0

func _ready():
	current_player = player_submarine
	background_theme.set_pitch_scale(4.0)
	background_theme.play()

func _process(_delta):
	if Input.is_action_just_pressed("ChangePlayer"):
		toggle_player()

func toggle_player():
	var new_player_type: int	
	if current_player_type == PlayerTypes.SUBMARINE:
		new_player_type = PlayerTypes.DUCK
	elif current_player_type == PlayerTypes.DUCK:
		new_player_type = PlayerTypes.SUBMARINE
	change_player(current_player_type, new_player_type)

func change_player(old_type, new_type):
	set_player_speed(old_type, speed_inactive)
	set_player_speed(new_type, speed_active)
	set_pitch_background(new_type)
	set_player(new_type)

func set_pitch_background(player_type):
	match player_type:
		PlayerTypes.SUBMARINE:
			background_theme.set_pitch_scale(1.0)
		PlayerTypes.DUCK:
			background_theme.set_pitch_scale(4.0)		

func set_player_speed(player_type, speed):
	match player_type:
		PlayerTypes.SUBMARINE:
			player_submarine.speed = speed
		PlayerTypes.DUCK:
			player_duck.speed = speed

func set_player(player_type):
	current_player_type = player_type

	match current_player_type:
		PlayerTypes.SUBMARINE:
			current_player = player_submarine
		PlayerTypes.DUCK:
			current_player = player_duck

	current_player.camera.make_current()
