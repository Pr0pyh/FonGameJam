class_name Contact
extends Resource


@export var name: String = "petar bezimeni"
@export var bad: bool = false
@export var talk_speed: float = 1.0
@export var voice_pitch: float = 1.0
@export var voice_loudness: float = 1.0
@export_multiline() var messages: Array[String]
