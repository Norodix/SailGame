extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu/TitleScreen.tscn")
	pass


func _on_Back_pressed():
	get_tree().change_scene("res://Menu/TitleScreen.tscn")
