extends CharacterBody2D

@onready var timer = $Timer
@onready var timer_2 = $Timer2
@onready var animated_sprite = $AnimatedSprite2D

var speed = 100
var direction = 1
var stop = false
var rng = RandomNumberGenerator.new()
var my_random_number = 0
var startHeight
#Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_node("Timer")
	var timer_2 = get_node("Timer2")
	timer.timeout.connect(_on_timer_timeout)
	timer_2.timeout.connect(_on_timer_2_timeout)
	speed = 10
	my_random_number = rng.randf_range(-10.0, 10.0)
	startHeight = position.y

	
		
	if (my_random_number < 0):
		animated_sprite.play("idle")
		direction = -1
		animated_sprite.flip_h = true
		timer_2.set_wait_time(my_random_number)
		
	elif (my_random_number > 0):
		animated_sprite.play("idle")
		direction = 1
		animated_sprite.flip_h = false
		timer_2.set_wait_time(my_random_number)
		
func _process(delta):	
	position.x += direction * speed * delta
	
	if(position.y > startHeight):
		position.y += -1 * speed * delta
	else:
		position.y = startHeight

	print(startHeight)
	print(position.y)
	
	if(stop == true):
		speed = 0
	elif(stop == false):
		speed = 100

func _on_timer_timeout():
	Engine.time_scale = 1
	direction = direction * -1
	speed = 0
	animated_sprite.flip_h = !animated_sprite.flip_h
	#print("timer")
	
		
func _on_timer_2_timeout():
	my_random_number = rng.randf_range(-10.0, 10.0)
	timer_2.set_wait_time(my_random_number)
	stop = !stop
	
func _physics_process(delta):		
	move_and_slide()
