extends Node2D

export(int, -1, 1) var turn_direction = 1
export var lifetime : float = 3.0
export var max_points : int = 10
export var trail_length : float = 200
export var wind_speed : float = 500
export var wind_direction = Vector2( 0.707107, 0.707107 )
export var width = 10
export var curl_time : float = 1.0
export var curl_tightness : float = 1.0
export var wave_length : float = 300
export var wave_amplitude : float = 50

const curl_tightness_multiplier = 20.0
var curl_angle = 0.0
var curled_direction = Vector2.ZERO
var point_delta

var time = 0.0
onready var line = $AntialiasedLine2D
var last_time = 0.0
var active = false

signal finished

func _ready():
	line.set_as_toplevel(true)
	reset()
	pass # Replace with function body.

#TODO trail length by skipping points
func _process(delta):
	if not active:
		return
	#line = $AntialiasedLine2D
	time += delta
	var point_count = line.get_point_count()
	line.modulate = Color(1, 1, 1, float(point_count)/float(max_points))
	line.width = width * float(point_count)/float(max_points)
	if time > lifetime:
		fade_out()
		return
	if lifetime - time < curl_time:
		curl_angle += curl_tightness * curl_tightness_multiplier * delta * delta * turn_direction
		curled_direction = curled_direction.rotated(curl_angle)
	
	var phase = global_position.dot(wind_direction) / wave_length * 2 * PI
	var wave_rotation = sin(phase)*wave_amplitude/wave_length
	self.global_position += (curled_direction.normalized() * wind_speed * delta).rotated(wave_rotation)
	#.rotated()
	
	if time - last_time >= point_delta:
		last_time = time
		#add point
		line.add_point(self.global_position)
		if point_count > max_points:
			line.remove_point(0)
	
	pass


func fade_out():
	var point_count = line.get_point_count()
	if (point_count) > 0:
		if (time > last_time + point_delta):
			line.remove_point(0)
			last_time = time
	else:
		reset()


func reset():
	curled_direction = wind_direction
	curl_angle = 0.0
	time = 0.0
	last_time = 0.0
	line.clear_points()
	self.global_position = Vector2.ZERO
	point_delta = trail_length / float(max_points) / wind_speed
	active = false
	#print("I finished: ", self)
	emit_signal("finished", self)
