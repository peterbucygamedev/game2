extends CharacterBody2D

const speed = 100
var direction = 1
@onready var animated_sprite = $AnimatedSprite2D
@onready var raycast_right = $RayCastRight
@onready var raycast_left = $RayCastLeft


func _process(delta):
	if raycast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if raycast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * speed * delta
