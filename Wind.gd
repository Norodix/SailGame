extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#set the rotation of the wind and its speed
	var world=get_node("..")
	var speed=world.windspeed.length()
	self.process_material.set("initial_velocity", speed)
	self.lifetime = 800/speed * 5
	self.rotation = - atan2(world.windspeed.y, world.windspeed.x)
	#self.position = (-Vector2(sqrt(500*500*2), 0)).rotated(self.rotation)
