extends HBoxContainer

@onready var text_container = $MarginContainerText
@onready var label = $MarginContainerText/MarginContainer/Label
@onready var timer = $Timer
@onready var audio_player = $AudioStreamPlayer

const MAX_WIDTH = 1024

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying()

func display_to_text(text_to_display: String, speech_sfx):
	text = text_to_display
	label.text = text
	audio_player.stream = speech_sfx

	global_position.x = 1920 / 2.0 - size.x / 2.0
	global_position.y = size.y / 2.0
	await resized

	label.text = ""
	display_letter()

func display_letter():
	if letter_index >= text.length():
		finished_displaying.emit()
		return

	label.text += text[letter_index]

	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return

	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)

			var new_audio_player = audio_player.duplicate()
			new_audio_player.pitch_scale += randf_range(-0.1, 0.1)
			if text[letter_index] in ["a", "e", "i", "o", "u"]:
				new_audio_player.pitch_scale += 0.2
			get_tree().root.add_child(new_audio_player)
			new_audio_player.play()
			await new_audio_player.finished
			new_audio_player.queue_free()

func _on_timer_timeout():
	display_letter()
