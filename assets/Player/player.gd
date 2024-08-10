extends CharacterBody2D


var speed = 120
var direction = 0.0
var jump = 250
const gravity = 10

func _physics_process(delta):
	direction = Input.get_axis("ui_left","ui_right")
	velocity.x = direction * speed
	
	if is_on_floor() && Input.is_action_just_pressed("ui_accept"):
		velocity.y -= jump
	
	if !is_on_floor():
		velocity.y += gravity
	
	if position.y > 300:
		position.y = 0
		position.x = 0
	
	move_and_slide()
