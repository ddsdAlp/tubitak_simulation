extends Node2D

var atoms = []
var simulation_speed: float = 1.0

# Preload the atom scene once
const ATOM_SCENE = preload("res://atom.tscn")

func _ready():
	# start the simulation
	set_process(true)

func _process(delta):
	if atoms.size() > 0:
		simulate()

var attraction_strength: float = 25.0
var repulsion_strength: float = 50.0
var attraction_threshold: float = 500.0  # Distance at which attraction starts
var repulsion_threshold: float = 5.0  # Distance below which repulsion kicks in

func calculate_forces(atom1: RigidBody2D, atom2: RigidBody2D):
	
	# distance between two atoms
	var distance = atom1.global_position.distance_to(atom2.global_position)
	if distance < 1.0:
		distance = 1.0
	
	var force = Vector2.ZERO
	
	if distance > repulsion_threshold:
		if distance < attraction_threshold:
			var attraction = attraction_strength / distance
			force = (atom2.global_position - atom1.global_position).normalized() * attraction
	else:
		var repulsion = repulsion_strength / (distance*distance)
		force = (atom2.global_position - atom1.global_position).normalized() * repulsion

	return force

func simulate():
	var total_forces = {}
	for atom in atoms:
		total_forces[atom] = Vector2.ZERO  # Initialize total forces to zero
	
	for i in range(atoms.size()):
		for j in range(i+1, atoms.size()):
			var force = calculate_forces(atoms[i], atoms[j])
			
			total_forces[atoms[i]] += force
			total_forces[atoms[j]] += -force
	
	for atom in atoms:
		atom.apply_central_impulse(total_forces[atom] * simulation_speed)
		atom.update_force_vector(total_forces[atom])

# adding new atoms to the simulation
var atom_type = "H"
func _input(event):
	if Input.is_action_just_pressed("1"):
		atom_type = "H"
	if Input.is_action_just_pressed("2"):
		atom_type = "O"
	if Input.is_action_just_pressed("3"):
		atom_type = "C"
	if Input.is_action_just_pressed("4"):
		atom_type = "Fe"
	
	
	if Input.is_action_just_pressed("left click"):
		var new_atom = ATOM_SCENE.instantiate()
		new_atom.update_atom(atom_type)
		new_atom.position = get_global_mouse_position()
		add_child(new_atom)
		atoms.append(new_atom)
