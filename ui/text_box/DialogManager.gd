class_name DialogManager

var text_box_scene = preload("res://ui/text_box/text_box.tscn")
var dialog_lines = []
var current_line_index = 0

var text_box
var text_box_position
var node

var is_dialog_active = false
var can_advance_line = false

var sfx

func _init(node_arg):
	node = node_arg

func start_dialog(position, lines, speech_sfx):
	if is_dialog_active:
		return

	dialog_lines = lines
	text_box_position = position
	sfx = speech_sfx
	show_text_box()

	is_dialog_active = true

func show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.connect("finished_displaying", on_finished_displaying)
	node.add_child(text_box)
	print(node)

	text_box.display_to_text(dialog_lines[current_line_index], sfx)
	can_advance_line = false

func on_finished_displaying():
	can_advance_line = true

func handle_input():
	if(
		Input.is_action_pressed("ADVANCE_DIALOG") &&
		is_dialog_active &&
		can_advance_line
	):
		text_box.queue_free()

		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			return

		show_text_box()
