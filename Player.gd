extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var movespeed = 500
var angularvelocity = 1.2
var angle = 0
var motorEnabled = 0

var zoomMax = 1.5
var zoomMin = 0.5
var zoomStep = 0.01

#Variables that store steering data
var turnLeft = 0
var turnRight = 0
var angular_velocity_current = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_global_position(get_viewport().size/3)
	pass # Replace with function body.
	
#helper function for mapping a->b range to c->d
func map(a, b, c, d, v):
	v = clamp(v, a, b)
	return (v-a)/(b-a) * (d-c) + c
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	drawArrow()
#	#Handle camera zoom
#	var zoomVal = $Camera2D.zoom[0]
##	if Input.is_action_just_released("zoomIn"):
##		zoomVal -= zoomStep*5
#	if Input.is_action_pressed("zoomIn"):
#		zoomVal -= zoomStep
#	#if Input.is_action_just_released("zoomOut"):
##		zoomVal += zoomStep*5
#	if Input.is_action_pressed("zoomOut"):
#		zoomVal += zoomStep
#
#	zoomVal = clamp(zoomVal, zoomMin, zoomMax)
#
#	$Camera2D.zoom = Vector2(zoomVal, zoomVal)


	#Steer with key events
	if Input.is_action_pressed("left"):
		turnLeft = true
	else:
		turnLeft = false
	
	if Input.is_action_pressed("right"):
		turnRight = true
	else:
		turnRight = false

	#Steer the ship if mouse is pressed somewhere
	if Input.is_action_pressed("MouseSteer"):
		#Mouse pressed is the same in case of touchscreen
		var facing=Vector2(cos(global_rotation), sin(global_rotation))
		var leftFacing = facing.rotated(deg2rad(-90))
		
		var mousePosition = get_viewport().get_mouse_position()
		var selfPosition = get_global_transform_with_canvas().origin
		var mouseRelativePosition = mousePosition - selfPosition
		
		#if too close to player, do not parse
		if ( mouseRelativePosition.length() > 20):
			# if left direction and mouse relative to player are in the same direction, turn left
			var sameDirection = mouseRelativePosition.normalized().dot(leftFacing.normalized())
			var tolerance = 0.05
			if(sameDirection > tolerance):
				turnLeft = true
				#go left
				pass
			if(sameDirection < -tolerance):
				turnRight = true
				#go right
				pass
				
	#Apply wind sound based on relative windspeed
	var Gwindspeed=get_node("/root/World").windspeed
	var wind = (Gwindspeed - self.linear_velocity).length()
	#var windDB = map(0, 400, -23, -5, wind)
	var windPitch = map(0, 400, 1, 6, wind)
	#$Wind.volume_db = windDB
	$Wind.pitch_scale = windPitch
	
	#Apply wave sound based on world speed
	var waveDB = map(0, 400, -27, -10, self.linear_velocity.length())
	var wavePitch = map(0, 400, 0.9, 1.5, self.linear_velocity.length())
	$Waves.volume_db = waveDB
	$Waves.pitch_scale = wavePitch
	#print("waveDB: ", waveDB);
	
	#Make the wake brighter as the ship is traveling faster
	var waveModColor = map(0, 400, 0, 0.6, self.linear_velocity.length())
	$Wake.modulate = Color(waveModColor, waveModColor, waveModColor)
	
	# Update rope properties
	var apparent_wind = get_node("/root/World").windspeed - self.linear_velocity
	var rope = get_node("../Rope")
	var flag = get_node("../Flag")
	rope.force = apparent_wind / 100.0
	#rope.length = $RopeAnchor.global_position.distance_to($Sail/RopeAnchor.global_position)
	#sin(deg2rad($Sail.maxangle / 2.0)) * 2 * 58
	rope.length = Vector2(-58, 0).distance_to(Vector2(-48, 0).rotated(deg2rad($Sail.maxangle)))
	flag.force = apparent_wind / 20.0
	

func drawArrow():
	var crate = get_node("../CrateArea")
	var visualSelf = get_node("../PlayerBoatSmoothing2D/BoatBodySmooth")
	var crateDirection = crate.global_position - visualSelf.global_position
	crateDirection=crateDirection.normalized()
	var start = crateDirection * 100 + visualSelf.global_position
	var end   = start + crateDirection * 20
	var arrowAngle = crateDirection.angle()
	$Arrow.global_rotation = arrowAngle + deg2rad(90)
	$Arrow.global_position = (start + end) / 2
	pass


func _integrate_forces(state):
	var angle_input = 0

	if self.turnLeft:
		angle_input += -1
	if self.turnRight:
		angle_input += 1
	
#	if motorEnabled: #obsolete
#		if Input.is_action_pressed("up"):
#			self.applied_force = Vector2(1000, 0).rotated(self.rotation)
#		elif Input.is_action_pressed("down"):
#			self.applied_force = Vector2(-1000, 0).rotated(self.rotation)
#		else:
#			self.applied_force = Vector2(0, 0)
	
	#calculate ship body direction
	var facing=Vector2(cos(global_rotation), sin(global_rotation))
	var normal=facing.rotated(deg2rad(90))
	#the body of the ship pushes against the water to keep down sideways motion
	self.linear_velocity -= (self.linear_velocity.dot(normal)*normal)*0.9
	#print("LinearVelocity: ", self.linear_velocity.length())
	var boatlabel=get_node("/root/World/GUI/Control/BoatSpeed")
	boatlabel.text="Boat speed: " + str(round(self.linear_velocity.length()))
	
	#control the body of the ship by rotating it
	var tartget_angular_velocity = angle_input * angularvelocity * (0.05 + self.linear_velocity.length()/200)
	angular_velocity_current = lerp(angular_velocity_current, tartget_angular_velocity, 0.05)
	state.set_angular_velocity(angular_velocity_current)
#	print("t: ", tartget_angular_velocity, "a: ", state.angular_velocity)

	
	#Apply the windforce on when the line is taut
	#Only apply force if it is in the same direction as the boat (pushback fix)
	
	var pushDirection = facing.dot($Sail.windForce)
	var validDirection = pushDirection >= 0

	if ($Sail.lineTaut and validDirection):
		self.applied_force = $Sail.windForce * 10
	else:
		self.applied_force = Vector2(0, 0)



func _on_CrateArea_pickUp():
	pass # Replace with function body.
