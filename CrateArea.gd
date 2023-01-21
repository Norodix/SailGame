extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maxRadius = 5000
var minRadius = 1000
var frameCount = 0

var sounds


# Called when the node enters the scene tree for the first time.
func _ready():
	frameCount = $AnimatedSprite.frames.get_frame_count("default")
	$AnimatedSprite.frame = randi() % frameCount
	
	sounds = [$Break_wood, 	#crate
			$Break_wood, 	#wheel
			$Break_metal, 	#anchorn
			$Break_glass, 	#lantern
			$Break_glass, 	#compass
			$Break_copper	#Sextant
			]
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal pickUp

func _on_CrateArea_body_entered(body):
	var boat = get_node("../PlayerBoat")
	if(body == boat):
		self.emit_signal("pickUp")
		var r=rand_range(minRadius, maxRadius)
		var angle = randf()*2*PI
		self.position += Vector2(cos(angle)*r, sin(angle)*r)
	
		sounds[$AnimatedSprite.frame].play()
		$AnimatedSprite.frame = randi() % frameCount

