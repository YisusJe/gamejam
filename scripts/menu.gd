extends Node

@export var start_button : Button
@export var exit_button : Button

func _ready():
	start_button.connect("pressed", on_start_button_pressed)
	exit_button.connect("pressed", on_exit_button_pressed)

func on_start_button_pressed():
	get_tree().change_scene_to_file("res://levels/main.tscn")

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://levels/menu/options_menu.tscn")

func _on_credits_button_pressed():
	pass

func on_exit_button_pressed():
	get_tree().quit()
