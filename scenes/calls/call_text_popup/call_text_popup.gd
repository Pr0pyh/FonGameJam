class_name CallTextPopup
extends Window


@export var rich_text_label: RichTextLabel
@export var nine_patch_rect: NinePatchRect

var is_on_left: bool = false
@onready var start_nine_patch_rect_x: float = nine_patch_rect.position.x


func _ready():
	rich_text_label.visible = false
	rich_text_label.text = ""
	for i in 5 + randi()%25:
		rich_text_label.text += str(randi()%5000, " ")
	await get_tree().process_frame
	await get_tree().process_frame
	rich_text_label.visible = true
	size = nine_patch_rect.size


func _process(delta):
	if is_on_left:
		nine_patch_rect.scale.x = -1
		nine_patch_rect.position.x = start_nine_patch_rect_x-25
	else:
		nine_patch_rect.scale.x = 1
		nine_patch_rect.position.x = start_nine_patch_rect_x
