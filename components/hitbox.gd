class_name Hitbox
extends Area2D

signal damage_applied
@export var damage: int = 1;

func _ready():
	connect("area_entered", on_area_entered)

func on_area_entered(area):
	if(area != null):
		damage_applied.emit()
