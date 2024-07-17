extends Node

const SONGS := {
	"gloomy_day": "res://audio/gloomy_day.mp3"
}

const AMBIENCE := {
	"forest": "res://audio/ambience/forest_ambience.mp3"
}

var current_song_name := ""
var current_ambience_name := ""

@onready var bgm1 := $bgm1
@onready var bgm2 := $bgm2
@onready var ambience1 := $ambience1
@onready var ambience2 := $ambience2


func _ready():
	Global.bgm_parser = self
	#playadwadwawwd("gloomy_day")
	play_ambience("forest")


func play_song(song):
	if !SONGS.has(song): return
	current_song_name = song
	if bgm1.playing:
		bgm2.set_stream(load(SONGS[song]))
		bgm2.play()
		return
	bgm1.set_stream(load(SONGS[song]))
	bgm1.play()


func play_ambience(ambience):
	if !AMBIENCE.has(ambience): return
	current_ambience_name = ambience
	if bgm1.playing:
		bgm2.set_stream(load(AMBIENCE[ambience]))
		bgm2.play()
		return
	bgm1.set_stream(load(AMBIENCE[ambience]))
	bgm1.play()
	
