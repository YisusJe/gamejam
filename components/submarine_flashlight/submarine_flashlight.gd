extends Marker2D

@onready var flashlight = $Flashlight
@onready var area = $Area2D
@onready var flashTimer = $Timer

@export var flashlightDuration = 10.0
var flashLightStarted = false

func _process(_delta):
	look_at(get_global_mouse_position())
	
	flashTimer.connect('timeout', out_of_flash)

func turn_on():
	if (flashLightStarted && flashTimer.get_time_left() == 0):
		turn_off()
		return
	area.get_child(0).disabled = false
	flashlight.enabled = true

	if (!flashLightStarted):
		flashLightStarted = true
		flashTimer.start(flashlightDuration)
	else:
		flashTimer.set_paused(false)

func turn_off():
	area.get_child(0).disabled = true
	flashlight.enabled = false
	flashTimer.set_paused(true)
	
func out_of_flash():
	print('No tienes flash')
	
