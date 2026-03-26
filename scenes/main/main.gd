class_name MainScene
extends Control


static var nokia_input_handled: bool = false
static var instance: MainScene


const NOKIA_SIZE: float = 0.65


@export var nokia_camera: Camera3D
@export var nokia: Nokia
@export var player: CharacterBody3D
@export var player_camera: Camera3D
@onready var start_player_camera_y: float = player_camera.position.y
@export var camera_horizontal_range: float = 5
@export var camera_vertical_range: float = 0.6

@export var left_wall_color_rect: ColorRect
@export var right_wall_color_rect: ColorRect
@export var top_wall_color_rect: ColorRect
@export var bottom_wall_color_rect: ColorRect

@export var nokia_subviewport: SubViewport
@export var nokia_subviewport_container: SubViewportContainer
@export var game_subviewport: SubViewport
@export var call_text_popup_container: CallTextPopupContainer
@export var call_container: CallContainer
@export var cover_animation_player: AnimationPlayer
@export var health_component: HealthComponent
@export var world_scene: PackedScene
@export var black_quad: MeshInstance3D
@export var screen_ui: Control
@export var photo_counter: PhotoCounter

@onready var start_player_transform: Transform3D = player.global_transform
@onready var start_player_camera_transform: Transform3D = player_camera.global_transform



var dragging_nokia: bool = false
var drag_nokia_start_offset: Vector2i
var camera_top_left: Vector3
var camera_bottom_right: Vector3
var current_window_position: Vector2i
var enemies_covering: int = 0
var is_camera_covered: bool = false
var camera_covered_t: float = 0.0
var health: int = 5
var world: Node3D
var dying: bool = false


func _enter_tree():
	instance = self


func _exit_tree():
	if instance == self:
		instance = null


func _ready():
	load_world()
	black_quad.visible = false
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(-1)
	var nokia_aspect_ratio: float = 0.5
	var screen_size: Vector2 = usable_rect.size
	var height: float = screen_size.y * NOKIA_SIZE
	var width: float = height * nokia_aspect_ratio
	get_window().size = Vector2(width,height)
	size = get_window().size
	current_window_position = usable_rect.size/2 - Vector2i(width, height)/2
	get_window().position = current_window_position
	await get_tree().process_frame
	await get_tree().process_frame
	update_camera_corners()
	update_nokia_camera_position()


func load_world():
	if world:
		world.queue_free()
	world = world_scene.instantiate()
	game_subviewport.add_child(world)
	Enemy.chasing_player_count = 0


func _process(delta):
	left_wall_color_rect.color.a = move_toward(left_wall_color_rect.color.a, 0.0, delta)
	right_wall_color_rect.color.a = move_toward(right_wall_color_rect.color.a, 0.0, delta)
	top_wall_color_rect.color.a = move_toward(top_wall_color_rect.color.a, 0.0, delta)
	bottom_wall_color_rect.color.a = move_toward(bottom_wall_color_rect.color.a, 0.0, delta)
	
	var rot_axis = Input.get_axis("move_left", "move_right")
	var move_axis = Input.get_axis("move_forward", "move_back")
	
	if abs(rot_axis) > 0.01:
		player.rotation.y -= rot_axis*delta*1.5
		update_camera_corners()
	
	if abs(move_axis) > 0.01:
		var dir = player_camera.global_basis.z
		dir.y = 0
		dir = dir.normalized()
		player.move_and_collide(dir * delta * move_axis*3.0)
		update_camera_corners()
	
	get_window().position = lerp(Vector2(get_window().position), Vector2(current_window_position), 15*delta)
	update_nokia_camera_position()
	#get_window().position = Vector2(current_window_position)
	_process_camera_covering(delta)


func _process_camera_covering(delta: float):
	if enemies_covering > 0:
		cover_animation_player.advance(2.0*delta)
	else:
		cover_animation_player.advance(-2.0*delta)
	
	if abs(cover_animation_player.current_animation_position-cover_animation_player.current_animation_length) < 0.02:
		if not is_camera_covered:
			camera_covered_t = 0.0
			is_camera_covered = true
		camera_covered_t -= delta
		if camera_covered_t <= 0:
			take_damage()
			camera_covered_t = 1.1
	else:
		is_camera_covered = false


func get_window_pos_part() -> Vector2:
	var window_pos: Vector2 = current_window_position
	var window_bounds: Array[Vector2] = get_window_bounds()
	var window_pos_part: Vector2
	window_pos_part.x = (window_pos.x-window_bounds[0].x) / (window_bounds[1].x - window_bounds[0].x)
	window_pos_part.y = (window_pos.y-window_bounds[0].y) / (window_bounds[1].y - window_bounds[0].y)
	return window_pos_part


func get_camera_pos_part() -> Vector2:
	var camera_pos_part: Vector2
	
	var camera_full_vector: Vector2 = \
		Vector2(camera_top_left.x, camera_top_left.z) \
		- Vector2(camera_bottom_right.x, camera_bottom_right.z)
	
	var camera_pos_vector: Vector2 = \
		Vector2(camera_top_left.x, camera_top_left.z) \
		- Vector2(player.global_position.x, player.global_position.z)
	
	camera_full_vector = camera_full_vector.rotated(-player.rotation.y)
	camera_pos_vector = camera_pos_vector.rotated(-player.rotation.y)
	camera_pos_part.x = camera_pos_vector.x / camera_full_vector.x
	camera_pos_part.y = (camera_top_left.y - player_camera.global_position.y) / (camera_top_left.y - camera_bottom_right.y)
	return camera_pos_part


func update_camera_corners():
	var window_pos_part: Vector2 = get_window_pos_part()
	var left_range: float = -(window_pos_part.x) * camera_horizontal_range
	var right_range: float = (1.0-window_pos_part.x) * camera_horizontal_range
	#var up_range: float = (window_pos_part.y) * camera_vertical_range
	#var down_range: float = -(1.0-window_pos_part.y) * camera_vertical_range
	#
	#
	#var pc_pos = player.global_position * Vector3(1,0,1) + player_camera.global_position * Vector3(0,1,0)
	
	camera_top_left = \
		player.global_basis.x * left_range + \
		player.global_position
	camera_bottom_right = \
		player.global_basis.x * right_range + \
		player.global_position
	
	camera_top_left.y = player.global_position.y + camera_vertical_range
	camera_bottom_right.y = player.global_position.y - camera_vertical_range


func update_camera_position():
	var old_player_position: Vector3 = player.global_position
	var window_pos_part: Vector2 = get_window_pos_part()
	var xz: Vector2 = lerp(
		Vector2(camera_top_left.x, camera_top_left.z), 
		Vector2(camera_bottom_right.x, camera_bottom_right.z), 
		window_pos_part.x)
	var y: float = lerp(camera_top_left.y, camera_bottom_right.y, window_pos_part.y)
	var target_position: Vector3 = Vector3(xz.x, 0.0, xz.y)
	player_camera.global_position.y = y + start_player_camera_y
	var move_vector: Vector3 = target_position - old_player_position
	var collision: KinematicCollision3D = player.move_and_collide(move_vector)
	if collision:
		if collision.get_normal().y > 0.2: bottom_wall_color_rect.color.a = 1.0
		elif collision.get_normal().y < -0.2: top_wall_color_rect.color.a = 1.0
		elif collision.get_normal().dot(player.global_basis.x) > 0.0: left_wall_color_rect.color.a = 1.0
		elif collision.get_normal().dot(player.global_basis.x) < 0.0: right_wall_color_rect.color.a = 1.0
		#player.move_and_collide(collision.get_remainder().slide(collision.get_normal()))
		update_window_position()
		DisplayServer.warp_mouse(current_window_position + drag_nokia_start_offset - get_window().position)
		window_pos_part = get_window_pos_part()
	player_camera.rotation_degrees.x = -(window_pos_part.y-0.5)*45.0
	player_camera.rotation_degrees.y = -(window_pos_part.x-0.5)*45.0
		


func update_window_position():
	var camera_pos_part: Vector2 = get_camera_pos_part()
	var bounds: Array[Vector2] = get_window_bounds()
	var x: float = lerp(bounds[0].x, bounds[1].x, camera_pos_part.x)
	#var y: float = lerp(bounds[0].y, bounds[1].y, camera_pos_part.y)
	current_window_position = Vector2(x,current_window_position.y)


func update_nokia_camera_position():
	var camera_pos_part: Vector2 = get_window_pos_part()
	nokia.scene_offset.x = 1.0-camera_pos_part.x-0.5
	nokia.scene_offset.y = camera_pos_part.y-0.5
	
	nokia_camera.look_at(nokia.scene_offset)


func get_window_bounds() -> Array[Vector2]:
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect()
	var left: float = -100.0 * NOKIA_SIZE
	var right: float = usable_rect.size.x - get_window().size.x + 100.0 * NOKIA_SIZE
	var top: float = -100.0 * NOKIA_SIZE
	var bottom: float = usable_rect.size.y - get_window().size.y + 500.0 * NOKIA_SIZE
	var top_left: Vector2 = Vector2(left, top)
	var bottom_right: Vector2 = Vector2(right, bottom)
	return [top_left, bottom_right]


func _on_nokia_sub_viewport_container_gui_input(event: InputEvent) -> void:
	if dying: return
	nokia_subviewport.push_input(event)
	if nokia_input_handled: 
		nokia_input_handled = false
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drag_nokia_start_offset = DisplayServer.mouse_get_position() - get_window().position
			dragging_nokia = event.pressed
	elif event is InputEventMouseMotion:
		if dragging_nokia:
			current_window_position = (DisplayServer.mouse_get_position() - drag_nokia_start_offset)
			var bounds: Array[Vector2] = get_window_bounds()
			current_window_position.x = clamp(current_window_position.x, bounds[0].x, bounds[1].x)
			current_window_position.y = clamp(current_window_position.y, bounds[0].y, bounds[1].y)
			update_camera_position()


func start_phone_call_incoming():
	nokia.start_phone_call_incoming()


func stop_phone_call_incoming():
	nokia.stop_phone_call_incoming()


func take_damage():
	nokia.take_damage()
	health -= 1
	if health <= 0:
		death()
	health_component._on_damage_taken()


func death():
	dying = true
	dragging_nokia = false
	load_world()
	world.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	health = 5
	cover_animation_player.advance(-INF)
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect()
	current_window_position = usable_rect.position + usable_rect.size/2 - get_window().size/2
	if call_container.current_call_panel:
		if call_container.current_call_panel.call_in_progress:
			call_container.current_call_panel.hang_up_call()
		else:
			call_container.current_call_panel.decline_call()
	black_quad.visible = true
	screen_ui.visible = false
	call_container.first_call = true
	call_container.call_timer = 2.0
	await get_tree().create_timer(2.0).timeout
	player.global_transform = start_player_transform
	player_camera.global_transform = start_player_camera_transform
	update_camera_corners()
	photo_counter.reset_counter()
	world.process_mode = ProcessMode.PROCESS_MODE_INHERIT
	screen_ui.visible = true
	black_quad.visible = false
	health_component.update_health()
	dying = false


func _on_nokia_input(event: InputEvent) -> void:
	if event.is_action_pressed("accept_call"):
		call_container._on_accept_call_pressed()
	elif event.is_action_pressed("decline_call"):
		call_container._on_decline_call_pressed()
	game_subviewport.push_input(event)
	get_viewport().push_input(event)
