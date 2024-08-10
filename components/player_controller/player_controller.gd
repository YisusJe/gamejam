class_name PlayerController
extends Node

enum PlayerTypes {
	SUBMARINE,
	DUCK
}

@export var current_player_type : PlayerTypes = PlayerTypes.SUBMARINE;
@export var player_submarine : PlayerSubmarine;
@export var player_duck : PlayerDuck;

var current_player;

func _ready():
	current_player = player_submarine

func _process(_delta):
	if Input.is_action_just_pressed("ChangePlayer"):
		if current_player_type == PlayerTypes.SUBMARINE:
			set_player(PlayerTypes.DUCK)
		elif current_player_type == PlayerTypes.DUCK:
			set_player(PlayerTypes.SUBMARINE)

func set_player(player_type):
	current_player_type = player_type

	match current_player_type:
		PlayerTypes.SUBMARINE:
			current_player = player_submarine
		PlayerTypes.DUCK:
			current_player = player_duck

	current_player.camera.make_current()
