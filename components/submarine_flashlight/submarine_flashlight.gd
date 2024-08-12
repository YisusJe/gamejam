extends Marker2D

@onready var flashlight = $Flashlight
@onready var area = $Area2D
@onready var flash_bar = $"../ProgressBar"
@export var flashlightDuration = 20.0
var flashLightStarted = false

func _ready():
	flash_bar.value = flashlightDuration

func _process(_delta):
	look_at(get_global_mouse_position())

func turn_on(delta):
	if (flashlightDuration <= 0):
		turn_off()
		return
	area.get_child(0).disabled = false
	flashlight.enabled = true
	flashlightDuration -= 1 * delta
	flash_bar.value = flashlightDuration

func turn_off():
	area.get_child(0).disabled = true
	flashlight.enabled = false
	recharge_duration()
	
func recharge_duration():
	flash_bar.value = 20.0

func out_of_flash():
	print('No tienes flash')

