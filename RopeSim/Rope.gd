extends Node2D

export var start_point : Vector2
export var start_lock = true
export var end_point : Vector2
export var end_lock = true
export var num_sections : int = 10
export var num_iterations : int = 10
export var length : float
export var force : Vector2 = Vector2.ZERO
export var damping = 1.0
export(NodePath) var startpoint_target
export(NodePath) var endpoint_target

onready var start_node = get_node_or_null(startpoint_target)
onready var end_node = get_node_or_null(endpoint_target)

class Point:
	var pos : Vector2
	var pos_tmp : Vector2
	var prev_pos: Vector2
	var locked : bool = false

class Stick:
	var pointA : Point
	var pointB : Point
	var length : float

var points = []
var sticks = []
var num_points
onready var line = $Line2D

func _ready():
	# create points
	num_points = num_sections+1
	for i in num_points:
		var p = Point.new()
		p.pos = lerp(start_point, end_point, float(i)/float(num_points))
		p.prev_pos = lerp(start_point, end_point, float(i)/float(num_points))
		points.append(p)
		line.add_point(p.pos)
	
	points[0].locked = start_lock
	points[-1].locked = end_lock
	
	# create sticks
	for i in num_sections:
		var s = Stick.new()
		s.pointA = points[i]
		s.pointB = points[i+1]
		s.length = length / float(num_sections)
		sticks.append(s)
	
	line.set_as_toplevel(true)
	line.z_index = self.z_index

func _process(delta):
	update_line()


func _physics_process(delta):
	if start_node != null:
		points[0].pos = start_node.global_position
	if end_node != null:
		points[-1].pos = end_node.global_position
	for i in num_points:
		var p = points[i]
		p.pos_tmp = p.pos
		if not p.locked:
			var offset = (p.pos - p.prev_pos + force * delta) * damping
			p.pos += offset
		p.prev_pos = p.pos_tmp

	for iter in num_iterations:
		var sticklen = length / float(num_sections)
		for i in num_sections:
			var s = sticks[i]
			var center = (s.pointA.pos + s.pointB.pos) / 2.0
			var dirAB = (s.pointB.pos - s.pointA.pos).normalized()
			if not s.pointA.locked:
				s.pointA.pos = center - dirAB * sticklen / 2.0
			if not s.pointB.locked:
				s.pointB.pos = center + dirAB * sticklen / 2.0


func update_line():
	for i in num_points:
		line.set_point_position(i, points[i].pos)

