extends RigidBody2D

var new_atom = Atom.new()

@onready var atom_label = $atom_label
@onready var force_vector = $force_vector
@onready var collision_shape = $CollisionShape2D


func _ready():
	# Set atom properties
	self.mass = new_atom.a_mass
	set_scale(Vector2(new_atom.a_radius, new_atom.a_radius) / 10.0)
	update_collision_shape()

func _draw():
	# Draw atom
	draw_circle(Vector2(0, 0), new_atom.a_radius, new_atom.a_color)
	atom_label.text = new_atom.a_symbol

func update_atom(symbol: String):
	new_atom.from_symbol(symbol)
	# Update atom properties
	self.mass = new_atom.a_mass
	set_scale(Vector2(new_atom.a_radius, new_atom.a_radius) / 10.0)
	update_collision_shape()
	
func update_collision_shape():
	if collision_shape and collision_shape.shape is CircleShape2D:
		# Update the radius of the collision shape to match the atom's radius
		var circle_shape = collision_shape.shape as CircleShape2D
		circle_shape.radius = new_atom.a_radius

func update_force_vector(force: Vector2):
	if force_vector:
		var scale_factor = 10
		var scaled_force = force * scale_factor # adjust as needed
		
		# Main line
		force_vector.points = [Vector2.ZERO, scaled_force]

