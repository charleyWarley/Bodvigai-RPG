extends CharacterBody2D
class_name Entity

var can_move := true
var direction := Vector2(0, 1)
var is_alive := true
var is_attacking := false
@onready var sprite = $AnimatedSprite2D
@onready var voice = $voice
@onready var sfx1 = $sfx1
@onready var sfx2 = $sfx2
@export var weapon : Node2D
@export var audios : Resource
@export var speed := 250


func _on_animated_sprite_2d_animation_looped():
	#if the attack animation is finished, 
	if sprite.animation.begins_with("attack"):
		weapon.is_attacking = false
		is_attacking = false


func _on_weapon_attack_state_changed(_is_attacking: bool):
	#update is_attacking variable if the weapon compoenet has started or stopped attacking
	is_attacking = _is_attacking


func check_flip():
	if direction.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true


func die():
	print("entity died")
	is_alive = false
	sprite.play("death")
	var random_index  = randi_range(1, 11)
	check_audio("pain" + str(random_index), true)


func check_audio(audio: String, is_voice: bool):
	#set the audio stream player for the audio
	var audio_player : AudioStreamPlayer2D = null
	if is_voice: 
		if !audios.voices.has(audio): return #if the audio doesn't exist, exit method
		audio_player = voice
	else:
		if !audios.sfxs.has(audio): return #if the audio doesn't exist, exit method
		if sfx1.playing: audio_player = sfx2 #if sfx1 is playing, set player to sfx2 to allow overlap with minimal cutoff
		else: audio_player = sfx1 #if it's not playing, set player to sfx1
	play_audio(audio, audio_player)


func play_audio(audio: String, audio_player: AudioStreamPlayer2D):
	var audio_path := "" #create path variable for the audio stream path
	#set the audio path from the audios resource
	if audio_player == voice: audio_path = audios.voices[audio]
	else: audio_path = audios.sfxs[audio]
	#set the audio stream in the audio player and play audio
	audio_player.set_stream(load(audio_path))
	audio_player.play()
	

func animate(action: String):
	var _direction := "" #create the direction string for the end of the animation string
	#set the direction string based on the direction of the entity
	if direction.x != 0: _direction = "_side"
	elif direction.y == 1: _direction = "_down"
	elif direction.y == -1: _direction = "_up"
	#create the animation string and play the animation on the animated sprite of the entity if that animation isn't already playing
	var animation = action + _direction
	if animation == sprite.animation: return
	sprite.play(animation)
