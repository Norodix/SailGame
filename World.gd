extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var windspeed=Vector2(50, 50)*3
var crateCount = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu/TitleScreen.tscn")
		
	#Change physics fps to frame fps so the animations are always smooth
	#might introduce lots of bugs, find better solution later
	#Engine.iterations_per_second = Engine.get_frames_per_second()






func _on_CrateArea_pickUp():
	crateCount += 1
	$GUI/CrateCounter.play("SizeBump")
	$GUI/CrateCounter/Control/Node2D/Label.text = "x " + var2str(crateCount)
