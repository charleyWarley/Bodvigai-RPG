extends StaticBody2D

@export var audios : Resource
@onready var sfx1 := $sfx1
@onready var sfx2 := $sfx2

func check_audio(audio: String, is_voice: bool):
	#set the audio stream player for the audio
	var audio_player : AudioStreamPlayer2D = null
	if !audios.sfxs.has(audio): return #if the audio doesn't exist, exit method
	if sfx1.playing: audio_player = sfx2 #if sfx1 is playing, set player to sfx2 to allow overlap with minimal cutoff
	else: audio_player = sfx1 #if it's not playing, set player to sfx1
	play_audio(audio, audio_player)


func play_audio(audio: String, audio_player: AudioStreamPlayer2D):
	var audio_path := ""
	audio_path = audios.sfxs[audio]
	audio_player.set_stream(load(audio_path))
	audio_player.play()
