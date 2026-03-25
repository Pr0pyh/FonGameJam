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
var covering: bool = false

func _ready():
	raycast.global_position = Vector3()
	raycast.global_rotation = Vector3()


func _exit_tree() -> void:
	if covering:
		covering = false
		MainScene.instance.enemies_covering -= 1


func _physics_process(delta: float) -> void:
	velocity.y -= gravity * delta
	_update_raycast()
	if should_chase():
		_process_chasing(delta)
	else:
		_process_idle(delta)
	move_and_slide()
	if not covering and should_cover():
		covering = true
		MainScene.instance.enemies_covering += 1
	elif covering and not should_cover():
		covering = false
		MainScene.instance.enemies_covering -= 1


func should_chase():
	return visiblity_notifier.is_on_screen() and \
		not raycast.is_colliding() and \
		get_distance_to_camera() < 6


func get_distance_to_camera():
	return visiblity_notifier.global_position.distance_to(get_viewport().get_camera_3d().global_position)


func should_cover():
	return chasing and get_distance_to_camera() < 0.9


func _update_raycast():
	var camera_position: Vector3 = get_viewport().get_camera_3d().global_position
	raycast.global_position = visiblity_notifier.global_position
	raycast.target_position = camera_position - raycast.global_position


func _process_chasing(delta: float):
	if not chasing:
		chasing = true
		chasing_player_count += 1
	sound_player.volume_linear = lerp(sound_player.volume_linear, 0.8, delta*4.0)
	if not sound_player.is_playing():
		sound_player.play()
	_process_movement_towards_player(delta)


func _process_idle(delta: float):
	if chasing:
		chasing = false
		chasing_player_count -= 1
	sound_player.volume_linear = lerp(sound_player.volume_linear, 0.0, delta*4.0)
	velocity.x = 0
	velocity.z = 0


func _process_movement_towards_player(delta: float):
	var camera: Camera3D = get_viewport().get_camera_3d()
	nav_agent.target_position = camera.global_position
	var direction_to_target: Vector3 = global_position.direction_to(nav_agent.get_next_path_position())
	direction_to_target = (direction_to_target * Vector3(1,0,1)).normalized()
	rotation.y = -Vector2(direction_to_target.x, direction_to_target.z).angle() + PI/2.0
	velocity.x = direction_to_target.x * movement_speed
	velocity.z = direction_to_target.z * movement_speed
