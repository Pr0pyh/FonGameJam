class_name Nokia
extends Node3D


signal input(event: InputEvent)


var buttons: Array[Area3D]

var currently_hovered_button: Area3D
var is_button_pressed: bool = false

func _ready() -> void:
	for child in get_children():
		if child is Area3D:
			child.input_ray_pickable = true
			child.mouse_entered.connect(_on_button_mouse_entered.bind(child))
			child.mouse_exited.connect(_on_button_mouse_exited.bind(child))
			buttons.append(child)


func _process(delta: float):
	#print(currently_hovered_button)
	for button: Area3D in buttons:
		var target_button_y: float = \
			0.025\
			-float(button == currently_hovered_button)*0.02 \
			-float(button == currently_hovered_button and is_button_pressed)*0.03
		button.position.y = lerp(button.position.y, target_button_y, 50.0*delta)


func _on_button_mouse_entered(button: Area3D):
	currently_hovered_button = button


func _on_button_mouse_exited(button: Area3D):
	if currently_hovered_button == button:
		if is_button_pressed:
			_on_button_pressed(button.name, false)
		currently_hovered_button = null
		is_button_pressed = false


func _on_button_pressed(button_name: String, pressed: bool):
	var event = InputEventAction.new()
	event.action = {
		"ButtonLeft": "move_left",
		"ButtonRight": "move_right",
		"ButtonUp": "move_forward",
		"ButtonDown": "move_down",
		"ButtonAccept": "accept_call",
		"ButtonDecline": "decline_call",
	}[button_name]
	event.pressed = pressed
	input.emit(event)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if currently_hovered_button:
				is_button_pressed = event.pressed
				_on_button_pressed(currently_hovered_button.name, event.pressed)
				if event.pressed:
					MainScene.nokia_input_handled = true
			
