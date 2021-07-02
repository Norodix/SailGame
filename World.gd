extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var windspeed=Vector2(50, 50)*3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()




