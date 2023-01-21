tool
extends Node2D
export(int, -1, 1) var turn_direction = 1
export var lifetime = 3.0
export var max_points = 10
export var wind_speed = 500
export var wind_direction = Vector2( 0.707107, 0.707107 )
export var width = 10
export var curl_time = 1.0
export var curl_tightness = 1.0

const curl_tightness_multiplier = 20.0
var curl_angle = 0.0
var curled_direction = Vector2.ZERO

var time = 0.0
onready var line = $Line2D

func _ready():
	$Line2D.set_as_toplevel(true)
	reset()
	pass # Replace with function body.

#TODO trail length by skipping points
func _process(delta):
	line = $Line2D
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
	
	self.global_position += curled_direction * wind_speed * delta
	line.add_point(self.global_position)
	if point_count > max_points:
		line.remove_point(0)
	
	pass


func fade_out():
	var point_count = line.get_point_count()
	if point_count > 0:
		line.remove_point(0)
	else:
		reset()


func reset():
	curled_direction = wind_direction
	curl_angle = 0.0
	time = 0.0
	line.clear_points()
	self.global_position = Vector2.ZERO
