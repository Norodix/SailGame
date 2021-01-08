extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var movespeed = 500
var angularvelocity = 0.1
var angle = 0
var motorEnabled = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_global_position(get_viewport().size/3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _integrate_forces(state):
	var angle = 0
	if Input.is_action_pressed("left"):
		angle += -1
	if Input.is_action_pressed("right"):
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
	#print(self.linear_velocity.length())
	
	#control the body of the ship by rotating it
	state.set_angular_velocity(angle * angularvelocity / state.get_step())
