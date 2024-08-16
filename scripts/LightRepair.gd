extends Area2D
class_name LightRepair	

@onready var label = $CollisionShape2D/Label
@export var action_name: String = 'interact'

var is_flash_broken = true

func _ready():
	label.hide()
#func _process(delta):

var interact: Callable = func():
	pass

func on_flashlight_broke():
	label.show()

