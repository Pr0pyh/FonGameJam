class_name CallPanel
extends Control

signal call_finished()
signal call_declined()
signal call_accepted()


@export var incoming_caller_name_label: Label
@export var incoming_caller_number_label: Label

@export var in_progress_caller_name_label: Label
@export var in_progress_call_time_label: Label

@export var contact_names_positives: Dictionary[String, bool]
@export var incoming_call_container: VBoxContainer
@export var call_in_progress_container: VBoxContainer

@onready var start_y: float = position.y

var is_positive_contact = true
var call_in_progress: bool = false

func spawn():
	visible = true
	var caller_name: String = contact_names_positives.keys().pick_random()
	incoming_caller_name_label.text = caller_name
	in_progress_caller_name_label.text = caller_name
	
	is_positive_contact = contact_names_positives[caller_name]
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", start_y - 80.0, 0.5)
	
	incoming_call_container.visible = true
	call_in_progress_container.visible = false


func accept_call():
	incoming_call_container.visible = false
	call_in_progress_container.visible = true
	call_in_progress = true


func decline_call():
	go_away()
	


func hang_up_call():
	go_away()


func go_away():
	var tween = create_tween()
	tween.tween_property(self, "position:y", start_y, 0.5)
	await tween.finished
	call_finished.emit()
	queue_free()
