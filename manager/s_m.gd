extends Node

##################################################
const BGM = preload("res://audio/time_for_adventure.mp3")
const JUMP_AUDIO = preload("res://audio/jump.wav")
const REWIND_AUDIO = preload("res://audio/power_up.wav")

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

##################################################
func _ready() -> void:
	sfx_player = AudioStreamPlayer.new()
	sfx_player.volume_db = -10.0
	add_child(sfx_player)
	
	bgm_player = AudioStreamPlayer.new()
	bgm_player.stream = BGM
	add_child(bgm_player)
	bgm_player.play()

##################################################
func jump_audio_play() -> void:
	sfx_player.stream = JUMP_AUDIO
	sfx_player.play()

##################################################
func rewind_audio_play() -> void:
	sfx_player.stream = REWIND_AUDIO
	sfx_player.play()
