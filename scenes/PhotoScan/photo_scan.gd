class_name PhotoScanner
extends Node3D

@onready var scan_raycast: RayCast3D = $ScanRaycast
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@export var crosshair: TextureRect
@export var photo_counter: PhotoCounter


var exploded_photo_t: float = 0.0


func _process(delta: float):
	if MainScene.instance.exploded:
		if MainScene.instance.nokia:
			exploded_photo_t -= delta
			if exploded_photo_t <= 0:
				anim_player.stop()
				anim_player.play("reset")
				anim_player.play("photo")
				audio_player.stop()
				audio_player.play()
				exploded_photo_t = randf()*0.3
	else:
		crosshair.modulate = Color(1, 1, 1, 1)
		if scan_raycast.is_colliding():
			var collider = scan_raycast.get_collider()
			if collider and collider.is_in_group("scanable"):
				crosshair.modulate = Color(0, 1, 0, 1)
				if Input.is_action_just_pressed("take_photo"):
					collider._on_shot()
					photo_counter.add_scanned_photo()
					anim_player.stop()
					anim_player.play("reset")
					anim_player.play("photo")
					audio_player.play()
