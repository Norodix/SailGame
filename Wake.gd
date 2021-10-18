extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# map input x to the specified range with clipping
func map(xIN, minIN, maxIN, minOUT, maxOUT):
	# Cap the input to the input range
	if (minIN>=maxIN):
		return 0
	if (minOUT>=maxOUT):
		return 0
	
	var x = xIN
	x = min(maxIN, x)
	x = max(minIN, x)
	var out = minOUT + (maxOUT-minOUT)/(maxIN-minIN)*(xIN-minIN)
	return out


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Follow rotation of the parent boat
	var parent=get_node("..")
	var v = parent.linear_velocity.length()
	
	# 0-100 velocity, 0.1 to 0.5 scale
	var scalefactor = map(v, 0, 100, 0.1, 0.5)
	
	#Emit amount factor 5 to 15 between 0 and 100
	var emitfactor = map(v, 0, 100, 5, 15)
	#self.amount=emitfactor
	if ( v < 10 ):
		self.emitting = false
	else:
		self.emitting = true
	self.process_material.set("angle", -parent.rotation_degrees - 90)
	#self.process_material.set("scale", scalefactor)
	#self.process_material.scale
