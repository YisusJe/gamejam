extends CharacterBody2D

@export var speed = 200
@export var attack_range = 100
@export var health = 100
@export var damage = 10
@export var patrol_points: Array[Vector2]  # Puntos de patrullaje

@onready var player = get_parent().get_node("Player")
@onready var anim = $AnimatedSprite2D

var current_patrol_index = 0
var is_attacking = false

enum EnemyState { PATROLLING, ATTACKING, IDLE }
var state = EnemyState.PATROLLING
