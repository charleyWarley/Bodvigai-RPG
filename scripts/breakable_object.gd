extends StaticBody2D
class_name BreakableObject

var is_alive = true
@export var audios : Resource
@onready var sfx1 := $sfx1
@onready var sfx2 := $sfx2
@onready var sprite := $AnimatedSprite2D
@export var animations : Resource


func _on_has_died():
	is_alive = false


func _ready():
	check_animation("idle")


func check_animation(action: String):
	#if the animation is already playing, exit method
	if action == sprite.animation: return
	var animation = action
	if animations.list.has(animation):
		animate(action, animation)


func animate(action: String, animation: String):
	print("animating ", animation)
	sprite.play(animation)
	check_audio(action)


########################################
#####Animation and Audio functions######
########################################

func check_audio(audio: String):
	var audio_type = audios.sfxs
	#set the audio stream player for the audio 
	var audio_player : AudioStreamPlayer2D
	if !audio_type.has(audio): return #if the audio doesn't exist, exit method
	#set audio player according to which one isn't playing
	if sfx1.playing: audio_player = sfx2 
	else: audio_player = sfx1
	#move on to the play audio method
	play_audio(audio, audio_player, audio_type)


func play_audio(audio: String, audio_player: AudioStreamPlayer2D, audio_type: Dictionary):
	var audio_path := "" #create the audio stream path
	audio_path = audio_type[audio] #set the audio path from the sfxs dictionary of the audios resource
	print(audio_path)
	#set the audio stream of the audio player and play audio
	audio_player.set_stream(load(audio_path)) 
	audio_player.play()
