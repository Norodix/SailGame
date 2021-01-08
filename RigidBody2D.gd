extends RigidBody2D

var maxangle=10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(self.rotation_degrees)


func _integrate_forces(state):

	if(self.rotation_degrees > maxangle):
		var angleerror=self.rotation_degrees - maxangle
		state.set_angular_velocity(angleerror / state.get_step())
	if(self.rotation_degrees < -maxangle):
		var angleerror=self.rotation_degrees + maxangle
		state.set_angular_velocity(angleerror / state.get_step())
	
