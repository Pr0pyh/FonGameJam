extends Control
class_name CallMessage

@onready var contact_label: Label = $Label

@export var contact_names_positives: Dictionary[String, bool]

func spawn():
	visible = true
	var rnum = randi_range(0, contact_names_positives.size()-1)
	contact_label.text = contact_names_positives.keys().pick_random()
	var tween = create_tween()
	tween.tween_property(self, "position", self.position+Vector2(0.0, -80.0), 0.5)
