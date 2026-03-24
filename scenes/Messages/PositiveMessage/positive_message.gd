extends Control
class_name PositiveMessage

@onready var contact_label: Label = $Label

@export var contact_names: Array[String]

func spawn():
	visible = true
	var rnum = randi_range(0, contact_names.size()-1)
	contact_label.text = contact_names[rnum]
