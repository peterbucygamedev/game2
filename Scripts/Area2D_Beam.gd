extends Area2D

var horizontalSpeed = 0
@onready var sprite_2d = $Sprite2D

func _physics_process(delta):
	position.x += horizontalSpeed * delta



func _on_area_entered(area):
	#print("area entered")
	area.queue_free()
	queue_free()
