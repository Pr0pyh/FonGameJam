class_name GaciceSpawner
extends Node3D


@export var gacice_scene: PackedScene


var gacice_present: int = 0
static var available_gacice_spawn_points: Array[Marker3D]
static var occupied_gacice_spawn_points: Array[Marker3D]



static func get_random_gace_room_name():
	if MainScene.instance.exploded: return ""
	return occupied_gacice_spawn_points.pick_random().name
	

func _ready():
	available_gacice_spawn_points.clear()
	occupied_gacice_spawn_points.clear()
	for child in get_children():
		if child is Marker3D:
			available_gacice_spawn_points.append(child)


func _process(delta):
	if not gacice_present >= 2:
		spawn_gacice()


func spawn_gacice():
	var spawn_point: Marker3D = available_gacice_spawn_points.pick_random()
	if spawn_point == null: return
	var gacice: Gacice = gacice_scene.instantiate()
	gacice.shot.connect(_on_gacice_shot.bind(gacice))
	available_gacice_spawn_points.erase(spawn_point)
	add_sibling(gacice)
	print(spawn_point.name)
	gacice.global_position = spawn_point.global_position
	gacice.spawn_point = spawn_point
	gacice_present += 1
	occupied_gacice_spawn_points.append(spawn_point)


func _on_gacice_shot(gacice: Gacice):
	occupied_gacice_spawn_points.erase(gacice.spawn_point)
	available_gacice_spawn_points.append(gacice.spawn_point)
	gacice_present -= 1
