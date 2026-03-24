class_name Nokia
extends Node3D


signal input(event: InputEvent)


var buttons: Array[Area3D]

var currently_hovered_button: Area3D
var is_button_pressed: bool = false
var phone_call_incoming: bool = false
var scene_offset: Vector3
var shake_offset: Vector3

var shaking: bool = false
var shake_strength: float = 0.02
var shake_frequency: float = 5000.0
var shake_noise := FastNoiseLite.new()

var shake_t: float
var vibration_t: float


@export var ringtone_sound_player: AudioStreamPlayer
@export var vibration_sound_player: AudioStreamPlayer

func _ready() -> void:
	for child in get_children():
		if child is Area3D:
			child.input_ray_pickable = true
			child.mouse_entered.connect(_on_button_mouse_entered.bind(child))
			child.mouse_exited.connect(_on_button_mouse_exited.bind(child))
			buttons.append(child)


func _process(delta: float):
	shake_t += delta*shake_frequency
	
	for button: Area3D in buttons:
		var target_button_y: float = \
			0.025\
			-float(button == currently_hovered_button)*0.02 \
			-float(button == currently_hovered_button and is_button_pressed)*0.03
		button.position.y = lerp(button.position.y, target_button_y, 50.0*delta)
	
	
	if phone_call_incoming:
		if not vibration_sound_player.is_playing():
			vibration_t += delta
			if vibration_t >= 0.5:
				vibration_sound_player.play()
				vibration_t = 0.0
		shaking = vibration_sound_player.is_playing()
	
	if shaking:
		shake_offset.x = shake_noise.get_noise_3d(shake_t, 0, 0)
		shake_offset.y = shake_noise.get_noise_3d(0, shake_t, 0)
		shake_offset.z = shake_noise.get_noise_3d(0, 0, shake_t)
		shake_offset *= shake_strength
	else:
		shake_offset = Vector3()
		
	global_position = scene_offset + shake_offset


func start_phone_call_incoming():
	vibration_t = 0.3
	ringtone_sound_player.play()
	phone_call_incoming = true


func stop_phone_call_incoming():
	shaking = false
	vibration_sound_player.stop()
	ringtone_sound_player.stop()
	phone_call_incoming = false


func _on_button_mouse_entered(button: Area3D):
	currently_hovered_button = button


func _on_button_mouse_exited(button: Area3D):
	if currently_hovered_button == button:
		if is_button_pressed:
			_on_button_pressed(button.name, false)
		currently_hovered_button = null
		is_button_pressed = false


func _on_button_pressed(button_name: String, pressed: bool):
	var action: String = {
		"ButtonLeft": "move_left",
		"ButtonRight": "move_right",
		"ButtonUp": "move_forward",
		"ButtonDown": "move_back",
		"ButtonAccept": "accept_call",
		"ButtonDecline": "decline_call",
	}[button_name]
	if pressed:
		Input.action_press(action)
	else:
		Input.action_release(action)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if currently_hovered_button:
				is_button_pressed = event.pressed
				_on_button_pressed(currently_hovered_button.name, event.pressed)
				if event.pressed:
					MainScene.nokia_input_handled = true
			
