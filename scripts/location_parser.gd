extends Node2D

const LOCATIONS = {
	"location_center" : "res://scenes/locations/location_center.tscn",
	"location_northwest" : "res://scenes/locations/location_northwest.tscn"
}
var current_location : Node2D = null
var current_location_name := ""
var updated_locations := {}
@onready var load_timer := $"../load_timer"
var player = null
var updated_player = null


func _on_load_timer_timeout():
	change_location("location_center")


func _ready():
	Global.location_parser = self
	load_timer.start()


func change_location(destination_key: String):
	if current_location != null: clear_current_location()
	var new_location : Node2D
	if updated_locations.has(destination_key):
		print("returning to an updated location")
		new_location = load(updated_locations[destination_key]).instantiate()
	else:
		print("discovering a new location")
		new_location = load(LOCATIONS[destination_key]).instantiate()
	call_deferred("load_new_location", new_location, destination_key)


func clear_current_location():
	save_updated_location()
	save_updated_player()
	player = null
	current_location.queue_free()
	current_location = null


func save_updated_location():
	var file_path = "res://temp/" + current_location.name + ".tscn"
	var packed_location = PackedScene.new()
	packed_location.pack(current_location)
	ResourceSaver.save(packed_location, file_path)
	var updated_location := {current_location_name: file_path}
	if updated_locations.find_key(current_location): updated_locations.erase(current_location)
	updated_locations.merge(updated_location)


func save_updated_player():
	var file_path = "res://temp/player.tscn"
	var packed_player = PackedScene.new()
	packed_player.pack(player)
	ResourceSaver.save(packed_player, file_path)


func load_new_location(new_location, destination_key):
	new_location.name = destination_key
	add_child(new_location)
	if player == null: load_player()
	else: remove_child(player)
	new_location.add_child(player)
	player.position = new_location.start_position.position
	Global.player_camera.set_limits(
		new_location.right_limit,
		new_location.left_limit, 
		new_location.top_limit,
		new_location.bottom_limit)


func load_player():
	var new_player = load("res://scenes/characters/player.tscn")
	player = new_player.instantiate()
