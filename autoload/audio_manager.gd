class_name SoundManager
extends Node


var no_combat_music_player: AudioStreamPlayer
var combat_music_player: AudioStreamPlayer


var playing_combat_music: bool = false

#func _ready() -> void:
	#no_combat_music_player = AudioStreamPlayer.new()
	#no_combat_music_player.stream = NO_COMBAT_MUSIC
	#add_child(no_combat_music_player)
	#no_combat_music_player.volume_linear = 0.0
	#no_combat_music_player.play()
	#combat_music_player = AudioStreamPlayer.new()
	#combat_music_player.stream = COMBAT_MUSIC
	#add_child(combat_music_player)
	#combat_music_player.volume_linear = 0.0
	#combat_music_player.play()


#func _process(delta):
	#playing_combat_music = bool(Enemy.chasing_player_count)
	#var combat_volume: float = float(playing_combat_music)
	#var no_combat_volume: float = float(not playing_combat_music)
	#combat_music_player.volume_linear = move_toward(combat_music_player.volume_linear, combat_volume, 5.0*delta)
	#no_combat_music_player.volume_linear = move_toward(no_combat_music_player.volume_linear, no_combat_volume, 5.0*delta)
	#
	#print(combat_music_player.volume_linear, " ",no_combat_music_player.volume_linear)
		
		
