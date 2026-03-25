class_name Gacice
extends Area3D

signal shot()


@export var gacice: Node3D

var time: float = 0.0
var spawn_point: Marker3D

@onready var gacice_y: float = gacice.position.y

func _process(delta):
	time += delta*5.0
	gacice.position.y = gacice_y + sin(time)*0.1
	gacice.rotation_degrees.y = fmod(time * 30.0, 360.0)


func _on_shot():
	shot.emit()
	queue_free()
