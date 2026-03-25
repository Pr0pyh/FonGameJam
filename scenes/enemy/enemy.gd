class_name Enemy
extends CharacterBody3D

static var chasing_player_count: int

@export var nav_agent: NavigationAgent3D
@export var visiblity_notifier: VisibleOnScreenNotifier3D
@export var sound_player: AudioStreamPlayer3D
@export var raycast: RayCast3D

var movement_speed: float = 2.0
var gravity: float = 15.0
var chasing: bool = false

func _ready():
	raycast.global_position = Vector3()
	raycast.global_rotation = Vector3()


func _physics_process(delta: float) -> void:
	velocity.y -= gravity * delta
	raycast.global_position = visiblity_notifier.global_position
	raycast.target_position = get_viewport().get_camera_3d().global_position - raycast.global_position
	if visiblity_notifier.is_on_screen() and not raycast.is_colliding():
		if not chasing:
			chasing = true
			chasing_player_count += 1
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
		if chasing:
			chasing = false
			chasing_player_count -= 1
		sound_player.volume_linear = lerp(sound_player.volume_linear, 0.0, delta*4.0)
		velocity.x = 0
		velocity.z = 0
	move_and_slide()
