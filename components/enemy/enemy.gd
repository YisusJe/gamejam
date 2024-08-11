extends CharacterBody2D

@export var player_submarine : PlayerSubmarine
@export var speed = 100
@onready var area = $Area2D

var is_attacking = true
var timer = null

func _ready():
	area.monitoring = true
	area.connect("area_entered", on_light_entered)

func _physics_process(_delta):
	var raw_velocity = position.direction_to(player_submarine.position) * speed
	velocity = raw_velocity if is_attacking else -raw_velocity # Move in opposite direction if illuminated

	move_and_slide()

func attack_player():
	is_attacking = true
	timer.queue_free()
	timer = null
	pass

func on_light_entered(_area):
	is_attacking = false

	if(timer):
		return

	timer = Timer.new()
	timer.wait_time = 2.0 # 1 second
	timer.one_shot = true # don't loop, run once
	timer.autostart = true # start timer when added to a scene
	timer.connect("timeout", attack_player)
	add_child(timer)
