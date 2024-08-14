extends CharacterBody2D

@export var player_submarine : PlayerSubmarine
@export var player_attacking_distance = 150
@export var player_hunting_distance = 200
@export var player_running_distance = 400
@export var threshold_timeout_attacking = 7
@onready var area = $Area2D
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var ray_cast_up = $RayCastUp
@onready var ray_cast_down = $RayCastDown
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_up_left = $RayCastUpLeft
@onready var ray_cast_up_right = $RayCastUpRight
@onready var ray_cast_down_left = $RayCastDownLeft
@onready var ray_cast_down_right = $RayCastDownRight
@onready var hitbox = $Hitbox

var is_attacking = true
var timer = null
var movement_mode : MovementModes = MovementModes.Hunting;
var timeout_attacking = threshold_timeout_attacking

enum MovementModes {
	Hunting,
	Attacking,
	Running
}

var rng = RandomNumberGenerator.new()

var rays = []

var radius = 1
var number_of_rays = 16

func _ready():
	area.monitoring = true
	area.connect("area_entered", on_light_entered)
	hitbox.connect("damage_applied", on_damage_applied)

	var step = 2 * PI / number_of_rays

	for i in range(number_of_rays):
		var ray = Vector2(1, 0).rotated(step * i)
		rays.append(ray)

func on_damage_applied():
	timeout_attacking = threshold_timeout_attacking
	start_running()

func get_dot_product_percentage(dot_product):
	return (dot_product + 1) / 2

func linear_interpolate(a, b, percentage):
	return a + ((b - a) * percentage)

func clamp_weight(weight):
	return clamp(weight, 0.0, 1.0)

func update_weights_by_collisions(rays_frame):
	var colliding_vectors = []
	var output = []

	var ray_cast_checks = [
		{
			'ray': ray_cast_up,
			'vector': Vector2(0, -1.0)
		},
		{
			'ray': ray_cast_down,
			'vector': Vector2(0, 1.0)
		},	
		{
			'ray': ray_cast_left,
			'vector': Vector2(-1.0, 0.0)
		},	
		{
			'ray': ray_cast_right,
			'vector': Vector2(1.0, 0.0)
		},	
		{
			'ray': ray_cast_up_left,
			'vector': Vector2(-0.7, -0.7)
		},	
		{
			'ray': ray_cast_up_right,
			'vector': Vector2(0.7, -0.7)
		},	
		{
			'ray': ray_cast_down_left,
			'vector': Vector2(-0.7, 0.7)
		},	
		{
			'ray': ray_cast_down_right,
			'vector': Vector2(0.7, 0.7)
		},	
	]

	for check in ray_cast_checks:
		if(check['ray'].is_colliding()):
			colliding_vectors.append(check['vector'])

	if (colliding_vectors.size() <= 0):
		return rays_frame
		
	for ray in rays_frame:
		var weight = ray['weight']

		for colliding_ray in colliding_vectors:
			var dot_product = ray['ray'].dot(colliding_ray)
			
			# Those that are pointing to the collision vector will have a weight of 0, as we can't move there
			if (dot_product > 0.5):
				weight = 0
			else:
				continue

			break

		output.append({
			'ray': ray['ray'],
			'weight': weight
		})

	return output

func update_weights_running(rays_frame, direction_to_player):
	var output = []

	for ray in rays_frame:
		var dot_product_percentage = get_dot_product_percentage(ray['ray'].dot(direction_to_player))
		var weight = ray['weight']

		# If ray points to player then it will reduce score by a maximum of 60% from 100%
		var weight_loss = linear_interpolate(0.6, 1, 1 - dot_product_percentage)

		output.append({
			'ray': ray['ray'],
			'weight': clamp_weight(weight * weight_loss)
		})

	return output

func update_weights_hunting(rays_frame, direction_to_player, closer_than_attacking_distance, further_than_hunting_distance):
	var output = []

	for ray in rays_frame:
		var dot_product_percentage = get_dot_product_percentage(ray['ray'].dot(direction_to_player))
		var weight = ray['weight']

		# If ray points to player direction then it will reduce score by a maximum of 60% from 100%
		var weight_loss = linear_interpolate(0.8, 1, 1 - dot_product_percentage)

		# Prioritize lateral movement
		if dot_product_percentage > 0.4 && dot_product_percentage < 0.6:
			weight_loss = 1.0
		# Move closer to player if further away than hunting distance
		if further_than_hunting_distance:
			weight_loss = linear_interpolate(0.5, 1, dot_product_percentage)

		output.append({
			'ray': ray['ray'],
			'weight': clamp_weight(weight * weight_loss)
		})

	return output


func update_weights_attacking(rays_frame, direction_to_player):
	var output = []

	for ray in rays_frame:
		var dot_product_percentage = get_dot_product_percentage(ray['ray'].dot(direction_to_player))
		var weight = ray['weight']

		# If ray doesn't point to intended direction then it will reduce score by a maximum of 0% from 100%
		var weight_loss = linear_interpolate(0.0, 1, dot_product_percentage)

		output.append({
			'ray': ray['ray'],
			'weight': clamp_weight(weight * weight_loss)
		})

	return output

func update_weights_on_intended_direction(rays_frame, direction):
	var output = []

	for ray in rays_frame:
		var dot_product_percentage = get_dot_product_percentage(ray['ray'].dot(direction))
		var weight = ray['weight']

		# If ray doesn't point to intended direction then it will reduce score by a maximum of 80% from 100%
		var weight_loss = linear_interpolate(0.8, 1, dot_product_percentage)

		output.append({
			'ray': ray['ray'],
			'weight': clamp_weight(weight * weight_loss)
		})

	return output

func update_weights_on_previous_best_ray(rays_frame, best_ray):
	var output = []

	for ray in rays_frame:
		var dot_product_percentage = get_dot_product_percentage(ray['ray'].dot(best_ray))
		var weight = ray['weight']

		# If ray doesn't point to intended direction then it will reduce score by a maximum of 80% from 100%
		var weight_loss = linear_interpolate(0.8, 1, dot_product_percentage)

		output.append({
			'ray': ray['ray'],
			'weight': clamp_weight(weight * weight_loss)
		})

	return output

var previous_best_ray = null
var previous_rays = []

# func _draw():
# 	for ray in previous_rays:
# 		var distance = ray['ray'] * ((100 * ray['weight']))

# 		draw_line(Vector2(0.0, 0.0), distance, Color.GREEN, 1.0)

# 	if previous_best_ray:
# 		draw_line(Vector2(0.0, 0.0), previous_best_ray * 100, Color.RED, 1.0)

func _physics_process(delta):
	print(Vector2(1.0, 1.0).normalized().x)

	var direction_to_player = position.direction_to(player_submarine.position)
	var distance_to_player = (player_submarine.position - position).length()
	var direction = direction_to_player
	var speed = 10 + rng.randf_range(0.0, 10.0)

	var rays_frame = []

	for ray in rays:
		rays_frame.append({
			'ray': ray,
			'weight': 1.0
		})

	rays_frame = update_weights_by_collisions(rays_frame)
	
	if (movement_mode == MovementModes.Hunting):
		anim.play("hunting")
		if (distance_to_player < player_hunting_distance):
			if (timeout_attacking <= 0):
				movement_mode = MovementModes.Attacking
			else:
				timeout_attacking -= 1 * delta
		if (previous_best_ray):
			rays_frame = update_weights_on_previous_best_ray(rays_frame, previous_best_ray)
		if (distance_to_player > player_hunting_distance):
			rays_frame = update_weights_on_intended_direction(rays_frame, direction)

		rays_frame = update_weights_hunting(rays_frame, direction_to_player, distance_to_player < player_attacking_distance, distance_to_player > player_hunting_distance)

		if (distance_to_player > player_hunting_distance):
			speed += rng.randf_range(50.0, 100.0)

		var percentage_speed = 1 - ease(distance_to_player / float(player_hunting_distance), -0.2)
		speed += percentage_speed * 200
	elif (movement_mode == MovementModes.Attacking):
		if (distance_to_player < 150):
			anim.play("attacking", 1.0)

		if (previous_best_ray):
			rays_frame = update_weights_on_previous_best_ray(rays_frame, previous_best_ray)
		rays_frame = update_weights_attacking(rays_frame, direction_to_player)
		var percentage_speed = 1 - ease((distance_to_player / float(player_attacking_distance)), 0.4)
		speed += rng.randf_range(100.0, 150.0)
		speed += percentage_speed * 2000
	elif (movement_mode == MovementModes.Running):
		anim.play("hunting")

		rays_frame = update_weights_on_intended_direction(rays_frame, -direction_to_player)
		rays_frame = update_weights_running(rays_frame, direction_to_player)
		speed = 500

	var max_weight = 0.0
	for ray in rays_frame:
		if ray['weight'] >= max_weight:
			max_weight = ray['weight']

	var best_rays = rays_frame.reduce(func(out, val): 
		if val['weight'] != max_weight:
			return out

		out.append(val)
		return out
	, [])
	var best_ray = best_rays.pick_random()['ray']

	if(previous_best_ray):
		previous_best_ray = best_ray
	else:
		previous_best_ray = best_ray
	previous_rays = rays_frame

	queue_redraw()

	velocity = velocity.lerp(speed * previous_best_ray, 0.03)

	if movement_mode == MovementModes.Running:
		sprite.flip_v = true if direction.x > 0 else false
		sprite.look_at(global_position - direction)
	else:
		sprite.flip_v = true if direction.x < 0 else false
		sprite.look_at(global_position + direction)

	move_and_slide()

func attack_player():
	movement_mode = MovementModes.Hunting
	timer.queue_free()
	timer = null

func on_light_entered(_area):
	start_running()

func start_running():
	previous_best_ray = null
	movement_mode = MovementModes.Running

	if(timer):
		return

	timer = Timer.new()
	timer.wait_time = 3.0 # 1 second
	timer.one_shot = true # don't loop, run once
	timer.autostart = true # start timer when added to a scene
	timer.connect("timeout", attack_player)
	add_child(timer)
