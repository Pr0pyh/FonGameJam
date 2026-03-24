class_name Enemy
extends CharacterBody3D



@export var nav_agent: NavigationAgent3D
@export var visiblity_notifier: VisibleOnScreenNotifier3D
@export var sound_player: AudioStreamPlayer3D

var movement_speed: float = 2.0
var gravity: float = 15.0

func _physics_process(delta: float) -> void:
	velocity.y -= gravity * delta
	if visiblity_notifier.is_on_screen():
		sound_player.volume_linear = lerp(sound_player.volume_linear, 0.8, delta*4.0)
		if not sound_player.is_playing():
			sound_player.play()
		var camera: Camera3D = get_viewport().get_camera_3d()
		nav_agent.target_position = camera.global_position
		var direction_to_target: Vector3 = global_position.direction_to(nav_agent.get_next_path_position())
		direction_to_target = (direction_to_target * Vector3(1,0,1)).normalized()
		rotation.y = -Vector2(direction_to_target.x, direction_to_target.z).angle() + PI/2.0
		velocity.x = direction_to_target.x * movement_speed
		velocity.z = direction_to_target.z * movement_speed
	else:
		sound_player.volume_linear = lerp(sound_player.volume_linear, 0.0, delta*4.0)
		velocity.x = 0
		velocity.z = 0
	move_and_slide()
