class_name HealthComponent
extends PanelContainer


@export var progress_bar: TextureProgressBar


func _ready():
	progress_bar.value = MainScene.instance.health
	modulate = Color(0,0,0,1)


func _process(delta):
	modulate.r = move_toward(modulate.r, 0.0, 20*delta)

func _on_damage_taken():
	modulate.r = 10.0
	update_health()


func update_health():
	progress_bar.value = MainScene.instance.health
