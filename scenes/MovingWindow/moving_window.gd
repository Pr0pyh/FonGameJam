extends Window

@export var _Camera: Camera3D 

var last_position: = Vector2.ZERO
var velocity: = Vector2.ZERO
var speed = 4

func _ready() -> void:
	#_Camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	transient = true
	close_requested.connect(quit)

func _process(delta: float) -> void:
	velocity = Vector2(position) - last_position
	last_position = Vector2(position)
	var window_position = get_camera_pos_from_window()
	#velocity = velocity.normalized()
	#_Camera.position = Vector3i(window_position.x, window_position.y, 0.0)
	_Camera.position += Vector3(velocity.x, -velocity.y, 0.0)*delta*speed
	#_Camera.position.x = clampf(-2.0, 2.0, _Camera.position.x)
	#_Camera.position.y = clampf(-2.0, 2.0, _Camera.position.y)
	print(_Camera.position)
	print(velocity)

func get_camera_pos_from_window() -> Vector2i:
	return Vector2(position) + velocity

func quit():
	get_tree().quit()
