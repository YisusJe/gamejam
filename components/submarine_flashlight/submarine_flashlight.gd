extends Marker2D

@onready var flashlight = $Flashlight
@onready var area = $Area2D

func _process(_delta):
	look_at(get_global_mouse_position())

func turn_on():
	area.get_child(0).disabled = false
	flashlight.enabled = true

func turn_off():
	area.get_child(0).disabled = true
	flashlight.enabled = false