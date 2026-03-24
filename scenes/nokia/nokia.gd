class_name Nokia
extends Node3D


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
		var target_button_y: float = - float(button == currently_hovered_button)*0.02 - float(is_button_pressed)*0.005
		button.position.y = lerp(button.position.y, target_button_y, 10.0*delta)


func _on_button_mouse_entered(button: Area3D):
	print("AAAAAAA")
	currently_hovered_button = button


func _on_button_mouse_exited(button: Area3D):
	print("BBBBB")
	if currently_hovered_button == button:
		currently_hovered_button = null
		is_button_pressed = false


func _on_button_pressed(button_name: String):
	print(button_name)
	


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if currently_hovered_button:
				is_button_pressed = event.pressed
				if event.pressed:
					_on_button_pressed(currently_hovered_button.name)
					MainScene.nokia_input_handled = true
			
