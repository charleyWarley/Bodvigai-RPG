extends RichTextLabel

const SPEED = -8
@onready var shadow := $shadow

func _ready():
	owner = null
	owner = get_parent().get_parent().get_parent()
	call_deferred("reparent", owner)
	set_damage_label_text(-8)


func _process(delta):
	var target_position = position.y + SPEED
	position.y = lerp(position.y, target_position, delta)


func set_damage_label_text(damage: int, note: String = ""):
	var _text : String
	if note != "":
		_text = note
		shadow.parse_bbcode("[center]" + _text + "[/center]")
		_text = "[color=BLUE]" + _text + "[/color]"
	else:
		_text = str(-damage)
		if sign(-damage) == 1: _text = "[color=SPRINGGREEN]" + _text + "[/color]"
		else: _text = "[color=RED]" + _text + "[/color]"
	_text = "[center]" + _text + "[/center]"
	parse_bbcode(_text)


func _on_timer_timeout():
	queue_free()
