extends Node

class_name Atom

var a_color
var a_radius: int
var a_mass: int
var a_symbol: String

var atom_data = {
	"H": { "color": Color(0, 1, 0), "radius": 10, "mass": 1 },
	"O": { "color": Color(0, 0, 1), "radius": 15, "mass": 16 },
	"C": { "color": Color(1, 0, 0), "radius": 20, "mass": 12 },
	"Fe": { "color": Color(0.65, 0.16, 0.16), "radius": 25, "mass": 56 }
}

func _init():
	a_color = Color(0, 1, 0) #white
	a_radius = 10
	a_mass = 1
	a_symbol = "H"

func from_symbol(symbol: String):
	if atom_data.has(symbol):
		var data = atom_data[symbol]
		a_color = data["color"]
		a_radius = data["radius"]
		a_mass = data["mass"]
		a_symbol = symbol
	else:
		print("unsupported atom symbol - atom data set to default")

