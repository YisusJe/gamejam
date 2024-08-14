extends Marker2D
class_name SubmarineFlashlight

@onready var flashlight = $Flashlight
@onready var area = $Area2D
@onready var flash_bar = $"../ProgressBar"
@export var flash_bar_value = 5.0

func _ready():
	flash_bar.value = flash_bar_value

func _process(_delta):
	look_at(get_global_mouse_position())

func turn_on():
	area.get_child(0).disabled = false
	flashlight.enabled = true

func turn_off():
	area.get_child(0).disabled = true
	flashlight.enabled = false

