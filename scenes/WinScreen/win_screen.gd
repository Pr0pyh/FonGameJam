extends Window

@export var win_counter = 10
@export var phone_counter: PhotoCounter
@export var anim_player: AnimationPlayer

func _ready() -> void:
	anim_player.animation_finished.connect(destroy)
	size = DisplayServer.screen_get_usable_rect().size
	position = DisplayServer.screen_get_usable_rect().position

func _process(delta: float) -> void:
	if phone_counter.counter >= win_counter:
		get_tree().paused = true
		anim_player.play("winanim")

func destroy(anim_name):
	get_tree().quit()
