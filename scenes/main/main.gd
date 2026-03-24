class_name MainScene
extends Control


const NOKIA_SIZE: float = 0.5


@export var player: CharacterBody3D
@export var nokia_texture_rect: TextureRect
@export var camera_horizontal_range: float = 10
@export var camera_vertical_range: float = 6

@export var left_wall_color_rect: ColorRect
@export var right_wall_color_rect: ColorRect
@export var top_wall_color_rect: ColorRect
@export var bottom_wall_color_rect: ColorRect


var dragging_nokia: bool = false
var drag_nokia_start_offset: Vector2i
var camera_top_left: Vector3
var camera_bottom_right: Vector3
var current_window_position: Vector2i


func _ready():
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(-1)
	var nokia_aspect_ratio: float = nokia_texture_rect.size.x / nokia_texture_rect.size.y
	var screen_size: Vector2 = usable_rect.size
	var height: float = screen_size.y * NOKIA_SIZE
	var width: float = height * nokia_aspect_ratio
	get_window().size = Vector2(width,height)
	size = get_window().size
	current_window_position = usable_rect.size/2 - Vector2i(width, height)/2
	update_camera_corners()


func _process(delta):
	left_wall_color_rect.color.a = move_toward(left_wall_color_rect.color.a, 0.0, delta)
	right_wall_color_rect.color.a = move_toward(right_wall_color_rect.color.a, 0.0, delta)
	top_wall_color_rect.color.a = move_toward(top_wall_color_rect.color.a, 0.0, delta)
	bottom_wall_color_rect.color.a = move_toward(bottom_wall_color_rect.color.a, 0.0, delta)
	var rot_axis = Input.get_axis("ui_left", "ui_right")
	var move_axis = Input.get_axis("ui_up", "ui_down")
	if abs(rot_axis) > 0.01:
		player.rotation.y -= rot_axis*delta
		update_camera_corners()
	elif abs(move_axis) > 0.01:
		player.global_position += player.global_basis.z * delta * move_axis
		update_camera_corners()
	get_window().position = current_window_position


func get_window_pos_part() -> Vector2:
	var window_pos: Vector2 = current_window_position
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect()
	var screen_size: Vector2 = Vector2(DisplayServer.screen_get_size())
	var window_pos_part: Vector2
	window_pos_part.x = window_pos.x / (usable_rect.size.x - get_window().size.x)
	window_pos_part.y = window_pos.y / (usable_rect.size.y - get_window().size.y)
	return window_pos_part


func get_camera_pos_part() -> Vector2:
	var camera_pos_part: Vector2
	var camera_full_vector: Vector2 = \
		Vector2(camera_top_left.x, camera_top_left.z) \
		- Vector2(camera_bottom_right.x, camera_bottom_right.z)
	var camera_pos_vector: Vector2 = \
		Vector2(camera_top_left.x, camera_top_left.z) \
		- Vector2(player.global_position.x, player.global_position.z)
	if camera_bottom_right.x == camera_top_left.x:
		camera_pos_part.x = camera_pos_vector.y / camera_full_vector.y
	else:
		camera_pos_part.x = camera_pos_vector.x / camera_full_vector.x
	camera_pos_part.y = (camera_top_left.y - player.global_position.y)/camera_vertical_range
	return camera_pos_part


func update_camera_corners():
	var window_pos_part: Vector2 = get_window_pos_part()
	var left_range: float = -(window_pos_part.x) * camera_horizontal_range
	var right_range: float = (1.0-window_pos_part.x) * camera_horizontal_range
	var up_range: float = (window_pos_part.y) * camera_vertical_range
	var down_range: float = -(1.0-window_pos_part.y) * camera_vertical_range
	
	camera_top_left = player.global_basis.x * left_range + player.global_basis.y * up_range + player.global_position
	camera_bottom_right = player.global_basis.x * right_range + player.global_basis.y * down_range + player.global_position


func update_camera_position():
	var old_player_position: Vector3 = player.global_position
	var window_pos_part: Vector2 = get_window_pos_part()
	var xz: Vector2 = lerp(
		Vector2(camera_top_left.x, camera_top_left.z), 
		Vector2(camera_bottom_right.x, camera_bottom_right.z), 
		window_pos_part.x)
	var y: float = lerp(camera_top_left.y, camera_bottom_right.y, window_pos_part.y)
	var target_position: Vector3 = Vector3(xz.x, y, xz.y)
	var move_vector: Vector3 = target_position - old_player_position
	var collision: KinematicCollision3D = player.move_and_collide(move_vector)
	if collision:
		if collision.get_normal().y > 0.2: bottom_wall_color_rect.color.a = 1.0
		elif collision.get_normal().y < -0.2: top_wall_color_rect.color.a = 1.0
		elif collision.get_normal().dot(player.global_basis.x) > 0.0: left_wall_color_rect.color.a = 1.0
		elif collision.get_normal().dot(player.global_basis.x) < 0.0: right_wall_color_rect.color.a = 1.0
		player.move_and_collide(collision.get_remainder().slide(collision.get_normal()))


func update_window_position():
	var camera_pos_part: Vector2 = get_camera_pos_part()
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect()
	current_window_position = Vector2(usable_rect.size - get_window().size) * camera_pos_part


func _on_nokia_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drag_nokia_start_offset = DisplayServer.mouse_get_position() - get_window().position
			dragging_nokia = event.pressed
	elif event is InputEventMouseMotion:
		if dragging_nokia:
			current_window_position = (DisplayServer.mouse_get_position() - drag_nokia_start_offset)
			var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect()
			
			current_window_position.x = clamp(current_window_position.x, 0, usable_rect.size.x - get_window().size.x)
			current_window_position.y = clamp(current_window_position.y, 0, usable_rect.size.y - get_window().size.y)
			update_camera_position()
			update_window_position()
			DisplayServer.warp_mouse(current_window_position + drag_nokia_start_offset - get_window().position)
