extends Particles2D

var player
var world

func _ready():
	player = get_node("/root/World/PlayerBoat")
	world = get_node("/root/World")
	
	
func _process(delta):
	#self.process_material.set_shader_param("spawnOrigin", player.position)
	#print(player.position)
	self.process_material.set_shader_param("overallVelocity", world.windspeed/2)
	pass
