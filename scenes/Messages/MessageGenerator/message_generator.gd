extends Node

@onready var timer: Timer = $MessageTimer
@export var call_message_scene: PackedScene

var messages: Array[CallMessage]

func _ready() -> void:
	timer.timeout.connect(spawn_message)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var popped_message = messages.pop_back()
		if popped_message != null: 
			if not popped_message.is_positive_contact:
				remove_health()
			print(popped_message.is_positive_contact)
			popped_message.queue_free()

func spawn_message():
	if not messages.is_empty():
		return
	var call_message = call_message_scene.instantiate()
	add_child(call_message)
	call_message.spawn()
	messages.push_back(call_message)

func remove_health():
	#TODO
	#da poziva zasebnu komponentu za oduzimanje healtha
	pass
