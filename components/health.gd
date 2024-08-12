class_name Health
extends Node

signal health_changed(difference: int)
signal health_depleted

@export var inmortality_duration : int = 10;
@export var max_health : int = 3;
@export var health : int = 3;

var inmortality_timeout = 0;

func _process(delta):
	if (inmortality_timeout >= 0):
		inmortality_timeout -= 1 * delta

func received_damage(damage):
	if (inmortality_timeout >= 0):
		return

	inmortality_timeout = inmortality_duration

	var clamped_health = clampi(health - damage, 0, max_health)

	if clamped_health != health:
		var difference = health - clamped_health
		health = clamped_health
		health_changed.emit(difference)
		
		if health == 0:
			health_depleted.emit()
