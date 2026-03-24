class_name MessageContainer
extends Control

@export var call_panel_scene: PackedScene

var current_call_panel: CallPanel

var call_timer: float = 0.0


func _process(delta):
	if not current_call_panel:
		call_timer -= delta
		if call_timer <= 0.0:
			spawn_call()


func spawn_call():
	var call_panel: CallPanel = call_panel_scene.instantiate()
	add_child(call_panel)
	call_panel.spawn()
	current_call_panel = call_panel


func _on_call_finished():
	current_call_panel = null
	call_timer = randf_range(3.0, 6.0)
