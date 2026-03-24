extends Node3D

@onready var scan_raycast: RayCast3D = $ScanRaycast
@onready var color_rect: TextureRect = $Crosshair
@export var photo_counter: PhotoCounter

func _process(delta: float):
	color_rect.modulate = Color(1, 1, 1, 1)
	if scan_raycast.is_colliding():
		var collider = scan_raycast.get_collider()
		color_rect.modulate = Color(0, 1, 0, 1)
		if collider.is_in_group("scanable") and Input.is_action_just_pressed("ui_accept"):
			photo_counter.add_scanned_photo()
			collider.queue_free()
