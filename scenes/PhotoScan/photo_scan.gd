class_name PhotoScanner
extends Node3D

@onready var scan_raycast: RayCast3D = $ScanRaycast
@export var crosshair: TextureRect
@export var photo_counter: PhotoCounter


func _process(delta: float):
	crosshair.modulate = Color(1, 1, 1, 1)
	if scan_raycast.is_colliding():
		var collider = scan_raycast.get_collider()
		if collider and collider.is_in_group("scanable"):
			crosshair.modulate = Color(0, 1, 0, 1)
			if Input.is_action_just_pressed("ui_accept"):
				collider._on_shot()
				photo_counter.add_scanned_photo()
