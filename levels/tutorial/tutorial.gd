extends Node2D

var speech_sound = preload("res://ui/text_box/voice.wav")

const lines = [
	"Welcome to the 23rd Submersible Division, recruit. Or should I say, Number 556. All the others? Missing in action.",
	"Your mission's simple. Get in that tin can we call a submarine, dive to the bottom, and collect those boxes of bread. Bread’s all that’s left worth fighting for. Bring 'em back, and maybe you'll live to do it again.",
    "Just remember, this isn't a pleasure cruise. Use the equipment, follow orders, and for the love of everything still above water, don't break military property. Submarines are expensive, and so is your training.",
    "Now, get to it. The ocean's not going to wait, and neither am I. Dismissed."
]

var dialog = null

func _ready():
    dialog = DialogManager.new(self)
    dialog.start_dialog(position, lines, speech_sound)

func _process(_delta):
    dialog.handle_input()