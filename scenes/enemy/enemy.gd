class_name Enemy
extends CharacterBody3D



@export var visiblity_notifier: VisibleOnScreenNotifier3D


func _physics_process(delta: float) -> void:
	if visiblity_notifier.is_on_screen():
		var direction_to_player: Vector3 = global_position.direction_to(get_viewport().get_camera_3d().global_position)
		rotation.y = -Vector2(direction_to_player.x, direction_to_player.z).angle() + PI/2.0
		move_and_collide(direction_to_player*delta)
