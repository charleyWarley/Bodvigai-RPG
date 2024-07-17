extends Camera2D

var horizontal_offset : Vector2 = Vector2(-512, 0)
var vertical_offset : Vector2 = Vector2(0, 0)

func _ready():
	enabled = true
	Global.player_camera = self


func set_limits(right_limit, left_limit, top_limit, bottom_limit):
	limit_right = right_limit
	limit_left = left_limit
	limit_top = top_limit
	limit_bottom = bottom_limit
