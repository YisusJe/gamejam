extends Area2D

@onready var container = $PlayerSubmarineContainer


func _on_body_entered(body):
	if body is PlayerSubmarine:

		var tween = create_tween()
		
		tween. tween_property(self, "position", position + Vector2(0,-30), 0.5)
		
		tween. tween_property(self, "modulate:a", 0.0, 0.5)
		Global.Box -= 1
		print(Global.Box)
		tween. tween_callback(self.queue_free)
		
		

