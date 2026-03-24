class_name CallTextPopup
extends Window


@export var rich_text_label: RichTextLabel
@export var nine_patch_rect: NinePatchRect

var is_on_left: bool = false
@onready var start_nine_patch_rect_x: float = nine_patch_rect.position.x


func _ready():
	rich_text_label.visible = false

func set_text(text: String):
	rich_text_label.text = text
	await get_tree().process_frame
	await get_tree().process_frame
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(rich_text_label, "scale", Vector2.ONE, 0.2).from(Vector2.ONE*0.5)
	rich_text_label.visible = true
	size = nine_patch_rect.size


func _process(delta):
	if is_on_left:
		nine_patch_rect.scale.x = -1
		nine_patch_rect.position.x = start_nine_patch_rect_x-25
	else:
		nine_patch_rect.scale.x = 1
		nine_patch_rect.position.x = start_nine_patch_rect_x
