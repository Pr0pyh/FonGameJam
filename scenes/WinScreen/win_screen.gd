extends Control

@export var win_counter = 10
@export var phone_counter: PhotoCounter
@export var anim_player: AnimationPlayer

func _ready() -> void:
	anim_player.animation_finished.connect(destroy)

func _process(delta: float) -> void:
	if phone_counter.counter >= win_counter:
		anim_player.play("winanim")

func destroy(anim_name):
	queue_free()
