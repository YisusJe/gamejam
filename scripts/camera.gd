extends Camera2D

func _process(delta):
	var window_size = DisplayServer.window_get_size()
	var mouse_pos = get_global_mouse_position()

	var new_offset = Vector2.ZERO
	new_offset.x = (mouse_pos.x - global_position.x) / (window_size.x / 2) * 100
	new_offset.y = (mouse_pos.y - global_position.y) / (window_size.y / 2) * 100

	offset = offset.lerp(new_offset, delta * 5)
