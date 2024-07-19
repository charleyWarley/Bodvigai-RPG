extends Node
class_name HealthComponent

@export var max_health := 10
@export var iframes_range := Vector2(0.2, 1.0)
@export var sprite : AnimatedSprite2D
@onready var iframes_timer := $iframes_timer
@onready var damage_label := preload("res://scenes/characters/damage_label.tscn")
var current_health : int
var is_invincible := false
var parent = get_parent()

func _on_iframes_timer_timeout():
	is_invincible = false
	sprite.self_modulate = Color("ffffff")


func _ready():
	parent = get_parent()
	current_health = max_health
	var iframes_time = randf_range(iframes_range.x, iframes_range.y)
	iframes_timer.wait_time = iframes_time


func _process(_delta):
	if current_health > 0: return
	if parent.has_method("die"): parent.die()
	current_health = 0
	set_process(false)


func take_damage(attack: Attack):
	if is_invincible: return
	current_health -= attack.attack_damage
	var new_damage_label = damage_label.instantiate()
	parent.add_child(new_damage_label)
	if parent.is_in_group("chests"):
		new_damage_label.set_damage_label_text(0, "open!")
	else:
		new_damage_label.set_damage_label_text(attack.attack_damage)
	parent.check_animation("take_damage")
	print(parent.name + " taking damage")
	sprite.self_modulate = Color("ffffff78")
	is_invincible = true
	iframes_timer.start()
