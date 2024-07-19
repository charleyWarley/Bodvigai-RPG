extends CharacterBody2D
class_name Entity

var direction := Vector2(0, 1)
var is_alive := true #a boolean for when the health component's health variable reaches 0 or lower, when true the entity's functions stop processing
var is_attacking := false
@onready var sprite = $AnimatedSprite2D
@onready var voice = $voice
@onready var sfx1 = $sfx1
@onready var sfx2 = $sfx2
@export var weapon : Node2D
@export var audios : Resource
@export var speed : int
@export var animations : Resource

func _on_animated_sprite_2d_animation_looped():
	#if the attack animation is finished, 
	if sprite.animation.begins_with("attack"):
		weapon.is_attacking = false
		is_attacking = false


func _on_weapon_attack_state_changed(_is_attacking: bool):
	#update is_attacking variable if the weapon compoenet has started or stopped attacking
	is_attacking = _is_attacking


func check_flip():
	#set the horizontal flip of the animated sprite
	if direction.x > 0: sprite.flip_h = false
	else: sprite.flip_h = true


func die():
	print(name + " has died")
	is_alive = false
	check_animation("die")
	


#####Animation and Audio functions

func check_animation(action: String, uses_voice: bool = true):
	var animation = action
	#if the animation can play without a direction, animate it and exit method
	if animations.list.has(animation):
		print(animation)
		animate(action, animation, uses_voice)
		return
	var _direction := "" #create the direction string for the end of the animation string
	#set the direction string based on the direction of the entity
	if direction.x != 0: _direction = "_side"
	elif direction.y == 1: _direction = "_down"
	elif direction.y == -1: _direction = "_up"
	animation += _direction
	#if the animation is already playing, exit method
	if animation == sprite.animation: 
		return
	animate(action, animation, uses_voice)


func animate(action: String, animation: String, uses_voice: bool):
	sprite.play(animation)
	check_audio(action, uses_voice)


func check_audio(audio: String, is_voice: bool):
	var audio_player : AudioStreamPlayer2D
	var audio_type : Dictionary
	if is_voice: 
		audio_type = audios.voices
		audio_player = voice
	else:
		#set the sfx audio player to whichever isnt playing
		audio_type = audios.sfxs
		if sfx1.playing: audio_player = sfx2
		else: audio_player = sfx1
	if !audio_type.has(audio): return #if the audio doesn't exist within the audio type, exit method
	play_audio(audio, audio_player, audio_type) #continue to the play audio method


func play_audio(audio: String, audio_player: AudioStreamPlayer2D, audio_type: Dictionary):
	var audio_path := "" #create path variable for the audio stream path
	var random_index = randi_range(1, audio_type[audio].size()) if audio_player == voice else randi_range(1, audio_type[audio]["grass"].size())
	if audio_player == voice: audio_path = audio_type[audio][random_index] #audios.voices[action][index]
	else: audio_path = audio_type[audio]["grass"][random_index] #audios.sfxs[action][environment][index]
	#set the audio stream in the audio player and play audio
	audio_player.set_stream(load(audio_path))
	audio_player.play()
