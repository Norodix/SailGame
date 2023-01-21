extends Node2D

export var spawn_extents = Vector2(1000, 600)
export var spawn_variation_range = 10
export var particle_count = 100
export var group_count_min = 3
export var group_count_max = 5
export var lifetime_min = 1.0
export var lifetime_max = 6.0
export var lifetime_variation = 0.2

onready var windparticle = preload("WindParticle.tscn")

var particles_active = []
var particles_passive = []


func _ready():
	for i in particle_count:
		var windparticle_instance = windparticle.instance()
		self.add_child(windparticle_instance)
		windparticle_instance.set_as_toplevel(true)
		windparticle_instance.connect("finished", self, "_on_particle_finished")
		particles_passive.append(windparticle_instance)
	pass # Replace with function body.


func _process(delta):
	if particles_passive.size() >= group_count_max:
		var spawnpoint = Vector2(randf()*spawn_extents.x, randf()*spawn_extents.y)
		var spawncount = randi() % (group_count_max - group_count_min) + group_count_min
		#spawnpoint /= 5.0
		var group_lifetime = range_lerp(randf(), 0, 1, lifetime_min, lifetime_max)
		for i in spawncount:
			var l = group_lifetime + rand_range(-1, 1) * lifetime_variation
			#var rot_dir = 1 if randi()%2 else -1
			var offset = Vector2(randf() - 0.5, randf() - 0.5) * spawn_variation_range
			var rot_dir = 1
			if offset.dot(Vector2(1, -1)) > 0:
				rot_dir = -1
			var pos = spawnpoint + offset
			
			spawn_particle(pos, l, rot_dir)
		pass


func spawn_particle(position, lifetime, turn_direction):
	var p = particles_passive[0]
	p.position = position
	p.lifetime = lifetime
	p.turn_direction = turn_direction
	p.active = true
	particles_passive.erase(p)
	particles_active.append(p)


func _on_particle_finished(particle):
	particles_active.erase(particle)
	particles_passive.append(particle)
