extends Control


func _ready():
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Play.grab_focus()
	pass # Replace with function body.



func _on_Play_pressed():
	get_tree().change_scene("res://World.tscn")
	pass # Replace with function body.


func _on_Tutorial_pressed():
	get_tree().change_scene("res://Menu/Tutorial.tscn")
	pass # Replace with function body.


func _on_Credits_pressed():
	get_tree().change_scene("res://Menu/Credits.tscn")
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit(0)
	pass # Replace with function body.



func _on_Patreon_pressed():
	OS.shell_open("https://www.patreon.com/Norodix")
	pass # Replace with function body.
