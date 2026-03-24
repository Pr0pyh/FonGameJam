extends Node

@onready var timer: Timer = $MessageTimer
@export var positive_message_scene: PackedScene

var messages: Array[PositiveMessage]

func _ready() -> void:
	timer.timeout.connect(spawn_message)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var popped_message = messages.pop_back()
		if(popped_message != null): 
			popped_message.queue_free()

func spawn_message():
	if not messages.is_empty():
		pass
	var positive_message = positive_message_scene.instantiate()
	add_child(positive_message)
	positive_message.spawn()
	messages.push_back(positive_message)
