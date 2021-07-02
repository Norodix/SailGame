extends RigidBody2D



var maxangle=30
var tightenpersec=45
var forceCoefficient=10
var windForce = Vector2(0, 0)
var lineTaut
var tautLimit = 0.999



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("tighten"):
		maxangle -= tightenpersec*delta
		if (maxangle<0):
			maxangle=0
		
	if Input.is_action_pressed("loosen"):
		maxangle += tightenpersec*delta
		if (maxangle>90):
			maxangle=90
	
	
func _integrate_forces(state):
	#Limit the angle of the sail to the specified value
	# if the sail reaches the limit, push animate the tightness
	var framenum=1
	var pinX = get_node("../PinJoint2D").position.x #should be 32
	#print(pinX)
	var parent=get_node("..")
	
	if (self.rotation_degrees > maxangle * tautLimit):
		self.rotation_degrees = maxangle
		self.angular_velocity *= 0.1
		#self.position = Vector2(-pinX, 0).rotated(self.rotation) + Vector2(pinX, 0)
		lineTaut=true
		framenum=2
		
	elif (self.rotation_degrees < -maxangle * tautLimit):
		self.rotation_degrees = -maxangle
		self.angular_velocity *= 0.1
		lineTaut=true
		#self.position = Vector2(-pinX, 0).rotated(self.rotation) + Vector2(pinX, 0)
		framenum=0
		
	else:
		lineTaut=false
	
	$Sail.frame=framenum
	
	#calculate the normal for the sail
	var facing=Vector2(cos(global_rotation), sin(global_rotation))
	var normal=facing.rotated(deg2rad(90))
	
	#get the wind speed relative to the sail
	var Gwindspeed=get_node("/root/World").windspeed
	#var wind = Gwindspeed - (parent.linear_velocity+self.linear_velocity)
	var wind = Gwindspeed - self.linear_velocity
	#print("Global wind: ", Gwindspeed, "\tlocal wind: ", wind, "\tParent V: ", parent.linear_velocity, "\tSelf: ", self.linear_velocity)
	#The sail excertes a push perpendicular to its surface
	windForce = (wind.dot(normal))*(normal)*forceCoefficient
	self.applied_force = windForce
	var windlabel=get_node("/root/World/GUI/Control/WindSpeed")
	windlabel.text="Wind speed: " + str(round(wind.length()))
	#print("Wind speed: ", wind.length())
