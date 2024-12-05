extends Node2D

var atoms = []
var simulation_speed: float = 1.0
var simulation_state = true

# Preload the atom scene once
const ATOM_SCENE = preload("res://Scenes/atom.tscn")

func _ready():
	# start the simulation
	set_process(true)

func _process(delta):
	handle_labels()
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
	
	
	if Input.is_action_just_pressed("space"):
		var new_atom = ATOM_SCENE.instantiate()
		new_atom.update_atom(atom_type)
		new_atom.position = get_global_mouse_position()
		add_child(new_atom)
		atoms.append(new_atom)



# handle signals
func _on_attraction_range_value_changed(value):
	attraction_threshold = value

func _on_attraction_strength_value_changed(value):
	attraction_strength = value

func _on_repulsion_range_value_changed(value):
	repulsion_threshold = value

func _on_repulsion_strength_value_changed(value):
	repulsion_strength = value

@onready var pause_button = $user_interface/VBoxContainer/pause_button
func _on_pause_button_pressed():
	get_tree().paused = !get_tree().paused
	pause_button.release_focus()

@onready var clear_button = $user_interface/VBoxContainer/clear_button
func _on_clear_button_pressed():
	for atom in atoms:
		atom.queue_free()
	atoms.clear()
	clear_button.release_focus()

# handle labels
@onready var attraction_range_label = $user_interface/VBoxContainer/VBoxContainer/attraction_range_label
@onready var attraction_strength_label = $user_interface/VBoxContainer/VBoxContainer2/attraction_strength_label
@onready var repulsion_range_label = $user_interface/VBoxContainer/VBoxContainer3/repulsion_range_label
@onready var repulsion_strength_label = $user_interface/VBoxContainer/VBoxContainer4/repulsion_strength_label

func handle_labels():
	attraction_range_label.text = "Attraction Range: " + str(attraction_threshold)
	attraction_strength_label.text = "Attraction Strength: " + str(attraction_strength)
	repulsion_range_label.text = "Repulsion Range: " + str(repulsion_threshold)
	repulsion_strength_label.text = "Repulsion Strength: " + str(repulsion_strength)
