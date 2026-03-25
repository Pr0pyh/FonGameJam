class_name CallContainer
extends Control

@export var call_panel_scene: PackedScene

var current_call_panel: CallPanel

var call_timer: float = 5.0


func _process(delta):
	if not current_call_panel and not MainScene.instance.dying:
		call_timer -= delta
		if call_timer <= 0.0:
			spawn_call()


func spawn_call():
	var call_panel: CallPanel = call_panel_scene.instantiate()
	
	add_child(call_panel)
	
	call_panel.call_accepted.connect(_on_call_accepted)
	call_panel.call_declined.connect(_on_call_declined)
	call_panel.call_finished.connect(_on_call_finished)
	
	call_panel.spawn()
	
	current_call_panel = call_panel


func _on_call_accepted():
	pass


func _on_call_declined():
	current_call_panel = null
	call_timer = get_call_timer()


func _on_call_finished():
	current_call_panel = null
	call_timer = get_call_timer()


func get_call_timer():
	return randf_range(10.0, 15.0)
