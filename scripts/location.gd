extends Node2D

@export var left_limit : int
@export var right_limit : int
@export var top_limit : int
@export var bottom_limit : int
@onready var start_position = $start_position

func _ready():
	Global.location_parser.current_location = self
	Global.location_parser.current_location_name = self.name
