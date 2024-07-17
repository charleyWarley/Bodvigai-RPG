extends Area2D

@export var destination_key := ""

func _on_body_entered(body):
	if body.name == "player":
		Global.location_parser.change_location(destination_key)
		
