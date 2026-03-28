class_name CallPanel
extends Control

signal call_finished()
signal call_declined()
signal call_accepted()


@export var incoming_caller_name_label: Label

@export var in_progress_caller_name_label: Label
@export var in_progress_call_time_label: Label
@export var voice_player: AudioStreamPlayer

@export var contacts: Array[Contact]
@export var incoming_call_container: VBoxContainer
@export var call_in_progress_container: VBoxContainer

@onready var start_y: float = position.y

@export var call_text_popup_scene: PackedScene
@export var dzon_tutorijal: Contact

var call_in_progress: bool = false
var call_time: float = 0.0
var message_timer: float = 0.5
var message_index: int
var contact: Contact
var gace_room_name: String

func spawn(first_call: bool):
	visible = true
	contact = contacts.pick_random()
	if first_call: contact = dzon_tutorijal
	voice_player.volume_linear = contact.voice_loudness*0.45
	voice_player.pitch_scale = contact.voice_pitch
	incoming_caller_name_label.text = contact.name
	in_progress_caller_name_label.text = contact.name
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", start_y - 100.0, 0.5)
	
	incoming_call_container.visible = true
	call_in_progress_container.visible = false
	
	gace_room_name = GaciceSpawner.get_random_gace_room_name().replace("_", ".")
	
	MainScene.instance.start_phone_call_incoming()


func _process(delta: float) -> void:
	if call_in_progress:
		call_time += delta
		
		update_call_time_label()
		message_timer -= delta
		if message_timer <= 0.0:
			message_timer = 3.0 / contact.talk_speed
		
			var call_text_popup: CallTextPopup = call_text_popup_scene.instantiate()
			MainScene.instance.call_text_popup_container.add_popup(call_text_popup)
			var message: String = contact.messages[message_index].replace("{GACE_ROOM}", gace_room_name) 
			call_text_popup.set_text(message)
			message_index = (message_index+1)%contact.messages.size()
			for i in 10:
				voice_player.play()
				await voice_player.finished
		
	if Input.is_action_just_pressed("accept_call"):
		accept_call()
	elif Input.is_action_just_pressed("decline_call"):
		if call_in_progress:
			hang_up_call()
		else:
			decline_call()


func update_call_time_label():
	var seconds = int(call_time)%60
	var minutes = int(call_time)/60%60
	var time_string: String = str(
		str(minutes).pad_zeros(2),
		":",
		str(seconds).pad_zeros(2)
	)
	in_progress_call_time_label.text = "Call in Progress - " + time_string


func accept_call():
	if call_in_progress: return
	if contact.bad:
		print("uf nije trebalo da se javis")
		MainScene.instance.take_damage()
	else:
		print("super sto si se javio")
	incoming_call_container.visible = false
	call_in_progress_container.visible = true
	call_in_progress = true
	MainScene.instance.stop_phone_call_incoming()
	call_accepted.emit()


func decline_call():
	call_declined.emit()
	MainScene.instance.stop_phone_call_incoming()
	go_away()
	


func hang_up_call():
	call_finished.emit()
	MainScene.instance.stop_phone_call_incoming()
	MainScene.instance.call_text_popup_container.clear_popups()
	go_away()


func go_away():
	var tween = create_tween()
	tween.tween_property(self, "position:y", start_y, 0.5)
	await tween.finished
	queue_free()
