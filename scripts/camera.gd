extends Camera2D

@export var random_strength : float = 30.0
@export var shake_fade : float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength = 0

func _process(delta):
	var window_size = DisplayServer.window_get_size()
	var mouse_pos = get_global_mouse_position()

	var new_offset = Vector2.ZERO
	new_offset.x = (mouse_pos.x - global_position.x) / (window_size.x / 2) * 100
	new_offset.y = (mouse_pos.y - global_position.y) / (window_size.y / 2) * 100

	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)

		offset = random_offset()

	new_offset = new_offset.lerp(new_offset, delta * 5)

func shake_camera():
	shake_strength = random_strength

func random_offset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))