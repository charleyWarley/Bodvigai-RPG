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


func _ready():
	print("bitch")


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
	var audio_path := ""
	if audio_player == voice: audio_path = audios.voices[audio]
	else: audio_path = audios.sfxs[audio]
	audio_player.set_stream(load(audio_path))
	audio_player.play()
	
