class_name Hurtbox
extends Area2D

@export var health : Health;

func _ready():
	connect("area_entered", on_area_entered)

func on_area_entered(hitbox: Hitbox):
	if(hitbox != null):
		health.received_damage(hitbox.damage)
