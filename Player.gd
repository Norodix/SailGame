extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var movespeed = 500
var angularvelocity = 0.02
var angle = 0
var motorEnabled = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_global_position(get_viewport().size/3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	
func _draw():
	var crate = get_node("../CrateArea")
	var crateDirection = crate.global_position - self.global_position
	crateDirection=crateDirection.normalized().rotated(-self.global_rotation)
	#crateDirection=crateDirection.rotated(-self.global_rotation)
	var start = crateDirection*100
	var end   = crateDirection*120
	draw_line(start, end, Color(1, 0, 0), 3, true)
	pass


func _integrate_forces(state):
	var angle = 0
	if Input.is_action_pressed("left"):
		angle += -1
	elif Input.is_action_pressed("right"):
		angle += 1
	
	if motorEnabled:
		if Input.is_action_pressed("up"):
			self.applied_force = Vector2(1000, 0).rotated(self.rotation)
		elif Input.is_action_pressed("down"):
			self.applied_force = Vector2(-1000, 0).rotated(self.rotation)
		else:
			self.applied_force = Vector2(0, 0)
	
	#calculate ship body direction
	var facing=Vector2(cos(global_rotation), sin(global_rotation))
	var normal=facing.rotated(deg2rad(90))
	#the body of the ship pushes against the water to keep down sideways motion
	self.linear_velocity -= (self.linear_velocity.dot(normal)*normal)*0.9
	#print("LinearVelocity: ", self.linear_velocity.length())
	var boatlabel=get_node("/root/World/GUI/Control/BoatSpeed")
	boatlabel.text="Boat speed: " + str(round(self.linear_velocity.length()))
	
	#control the body of the ship by rotating it
	#do not allow rotating the body if not by user
	if (angle != 0):
		state.set_angular_velocity(angle * angularvelocity / state.get_step() \
									* (0.05 + self.linear_velocity.length()/200))
	else:
		state.set_angular_velocity(0)
		
	#Apply the windforce on when the line is taut
	#print($Sail.lineTaut)
	if ($Sail.lineTaut):
		#Only apply force if it is in the same direction as the boat (pushback fix)
		if (facing.dot($Sail.windForce) >= 0):
			self.applied_force = $Sail.windForce * 10
	else:
		self.applied_force = Vector2(0, 0)

