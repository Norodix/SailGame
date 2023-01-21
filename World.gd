extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var windspeed=Vector2(50, 50)*3
var crateCount = 0
var save_data = {
		"score" : 0,
	}
const savename = "user://Sailsave.save"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	load_game()
	crateCount = save_data["score"]
	$GUI/CrateCounter/Control/Node2D/Label.text = "x " + var2str(crateCount)
	


func _process(delta):
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu/TitleScreen.tscn")
		
	#Change physics fps to frame fps so the animations are always smooth
	#might introduce lots of bugs, find better solution later
	#Engine.iterations_per_second = Engine.get_frames_per_second()


func load_game():
	var save_game = File.new()
	if not save_game.file_exists(savename):
		return # Error! We don't have a save to load.

	save_game.open(savename, File.READ)
	var loaded_save = save_game.get_var()

	if loaded_save.has("score"):
		save_data["score"] = loaded_save["score"]
	save_game.close()


func save_game():
	var save_game = File.new()
	save_game.open(savename, File.WRITE)
	save_game.store_var(save_data)	
	save_game.close()



func _on_CrateArea_pickUp():
	crateCount += 1
	$GUI/CrateCounter.play("SizeBump")
	$GUI/CrateCounter/Control/Node2D/Label.text = "x " + var2str(crateCount)
	save_data.score = crateCount
	save_game()
