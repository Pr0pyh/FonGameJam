class_name GaciceSpawner
extends Node3D


@export var gacice_scene: PackedScene


var gacice_present: int = 0
var available_gacice_spawn_points: Array[Marker3D]


func _ready():
	for child in get_children():
		if child is Marker3D:
			available_gacice_spawn_points.append(child)


func _process(delta):
	if not gacice_present > 2:
		spawn_gacice()


func spawn_gacice():
	var spawn_point: Marker3D = available_gacice_spawn_points.pick_random()
	var gacice: Gacice = gacice_scene.instantiate()
	available_gacice_spawn_points.erase(spawn_point)
	add_sibling(gacice)
	print(spawn_point.name)
	gacice.global_position = spawn_point.global_position
	gacice.spawn_point = spawn_point
	gacice_present += 1


func _on_gacice_shot(gacice: Gacice):
	available_gacice_spawn_points.append(gacice.spawn_point)
	gacice_present -= 1
