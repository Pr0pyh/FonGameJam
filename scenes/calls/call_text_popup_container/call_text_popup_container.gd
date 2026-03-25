class_name CallTextPopupContainer
extends Control


var popups: Array[CallTextPopup]
var margin: float = 10.0


func add_popup(call_text_popup: CallTextPopup):
	add_child(call_text_popup)
	popups.append(call_text_popup)
	call_text_popup.tree_exited.connect(popups.erase.bind(call_text_popup))


func _process(delta):
	var pos: Vector2i
	var is_on_left: bool = false
	var window: Window = MainScene.instance.get_window()
	var window_x: float = window.position.x - float(window.size.x)/2
	if window_x > float(DisplayServer.screen_get_usable_rect().size.x)/2:
		pos = window.position + Vector2i(300, 100)
		is_on_left = true
	else:
		pos = window.position + window.size.x * Vector2i(1,0) + Vector2i(0, 100)
	for popup: CallTextPopup in popups:
		popup.is_on_left = is_on_left
		popup.position = pos
		pos.y += popup.size.y + margin
	

func clear_popups():
	for popup in popups:
		popup.queue_free()
	popups.clear()
