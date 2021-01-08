extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maxangle=30
var tightenpersec=45
var wind=Vector2(500, 500)


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
	if (self.rotation_degrees > maxangle):
		self.rotation_degrees=maxangle
		self.angular_velocity=0
	if (self.rotation_degrees < -maxangle):
		self.rotation_degrees=-maxangle
		self.angular_velocity=0
	
	#calculate the normal for the sail
	var facing=Vector2(cos(global_rotation), sin(global_rotation))
	var normal=facing.rotated(deg2rad(90))
		
	#The sail excertes a push perpendicular to its surface
	self.applied_force = (wind.dot(normal))*(normal)
	
