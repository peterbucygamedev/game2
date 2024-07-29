extends CharacterBody2D
@onready var hands = $Hands
@onready var animated_sprite = $AnimatedSprite2D
const beamPath = preload('res://Scenes/beam.tscn')
var lastDirection = 0
var storeHorizontalSpeed = 0;
var isShooting = false
var speed = 20.0
var environmentSpeed = 20
var JUMP_VELOCITY = -300.0
const beamSpeed = 500
var jumped = false
var doubleJump = false
var isRunning = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func shoot():
	var b = beamPath.instantiate()
	add_child(b)
	b.position = hands.global_position
	
	if lastDirection == -1:
		b.horizontalSpeed = -beamSpeed;

	elif lastDirection == 1:
		b.horizontalSpeed = beamSpeed;
	


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and position.y <= 0:
		velocity.y += gravity * delta
		environmentSpeed = 1
		JUMP_VELOCITY = -300.0
	elif not is_on_floor() and position.y > 0:
		velocity.y += gravity/2 * delta
		environmentSpeed = 0.2
		JUMP_VELOCITY = -170.0
	#if not is_on_floor() and position.y < 22:
		#velocity.y += gravity/10 * delta
	#print(position.y)
	#print(velocity.y)
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumped = !jumped
		#print("jump")
		
	if Input.is_action_just_pressed("jump") and !is_on_floor() and jumped == true:
		if(position.y <= 0):
			velocity.y = JUMP_VELOCITY
			jumped = false
			doubleJump = true
			
		elif(position.y > 0):
			velocity.y = JUMP_VELOCITY
			jumped = true
			doubleJump = true
		#print("doublejump")
		
	if is_on_floor():
		doubleJump = false
		
	if Input.is_action_just_pressed("shoot_beam"):
		shoot()
		#print("isshooting") 
		
	if Input.is_action_pressed("run"):
		#print("isrunning")
		isRunning = true
		speed = 200 * environmentSpeed
	else:
		isRunning = false
		speed = 100 * environmentSpeed
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right") 
	
	if direction > 0:
		animated_sprite.flip_h = false
		lastDirection = 1

	elif direction < 0:
		animated_sprite.flip_h = true
		lastDirection = -1

	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		elif direction != 0 and isRunning == false:
			if (position.y <= 0):
				animated_sprite.play("walk")
			elif (position.y > 0):
				animated_sprite.play("swim")
		elif direction != 0 and isRunning == true:
			if (position.y <= 0):
				animated_sprite.play("run")
			elif (position.y > 0):
				animated_sprite.play("swim_fast")
			
	elif(jumped == true):
		if (position.y <= 0):
			animated_sprite.play("jump")
		elif (position.y > 0 and isRunning == false):
			animated_sprite.play("swim")
		elif (position.y > 0 and isRunning == true):
			animated_sprite.play("swim_fast")
		
	elif !is_on_floor() and doubleJump == true:
		if (position.y <= 0):
			animated_sprite.play("double_jump")
		elif (position.y > 0 and isRunning == false):
			animated_sprite.play("swim")
		elif (position.y > 0 and isRunning == true):
			animated_sprite.play("swim_fast")
		
			
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
