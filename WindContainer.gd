extends ViewportContainer

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/PlayerBoat")
	pass # Replace with function body.


func _process(delta):
	#self.rect_position = player.position + Vector2(-1024, -1024)
	pass
	
