extends Window

@export var _Camera: Camera3D 

var last_position: = Vector2.ZERO
var velocity: = Vector2.ZERO
var speed = 4

func _ready() -> void:
	#_Camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	transient = true
	close_requested.connect(quit)
	last_position = Vector2(position)

func _physics_process(delta: float) -> void:
	velocity = Vector2(position) - last_position
	last_position = Vector2(position)
	var x = position.x*9/1920.0-4.5
	var y = position.y*5/1080.0-2.5
	var window_position = get_camera_pos_from_window()
	velocity = velocity.normalized()
	_Camera.position = Vector3(x, -y, _Camera.position.z)
	#_Camera.position += Vector3(velocity.x, -velocity.y, 0.0)*delta*speed
	print(position)
	print(velocity)

func get_camera_pos_from_window() -> Vector2i:
	return Vector2(position) + velocity

func quit():
	get_tree().quit()
