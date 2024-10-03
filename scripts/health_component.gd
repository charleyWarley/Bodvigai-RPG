extends Node
class_name HealthComponent

signal has_died()
signal stun_state_changed(_is_stunned: bool)

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


func _on_stun_timer_timeout():
	print("no longer stunned")
	emit_signal("stun_state_changed", false)


func _on_hitbox_component_attack_blocked():
	create_damage_label(0, "blocked!")


func _ready():
	parent = get_parent()
	current_health = max_health
	var iframes_time = randf_range(iframes_range.x, iframes_range.y)
	iframes_timer.wait_time = iframes_time


func _process(_delta):
	if current_health > 0: return
	emit_signal("has_died")
	current_health = 0
	set_process(false)


func take_damage(attack: Attack):
	if is_invincible: return

	current_health -= attack.attack_damage
	if parent.is_in_group("chests"):
		create_damage_label(0, "open!")
	else:
		create_damage_label(attack.attack_damage)
	parent.check_animation("take_damage")
	print(parent.name + " taking damage")
	sprite.self_modulate = Color("ffffff78")
	is_invincible = true
	iframes_timer.start()


func create_damage_label(hp: int, text: String = ""):
	var new_damage_label = damage_label.instantiate()
	parent.add_child(new_damage_label)
	new_damage_label.set_damage_label_text(hp, text)
