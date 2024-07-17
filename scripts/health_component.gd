extends Node
class_name HealthComponent

@export var max_health := 10.0
@export var iframes_range := Vector2(0.2, 1.0)
@export var sprite : AnimatedSprite2D
@onready var iframes_timer := $iframes_timer
var current_health : float 
var is_invincible := false


func _on_iframes_timer_timeout():
	is_invincible = false
	sprite.self_modulate = Color("ffffff")


func _ready():
	current_health = max_health
	var iframes_time = randf_range(iframes_range.x, iframes_range.y)
	iframes_timer.wait_time = iframes_time


func take_damage(attack: Attack) -> float:
	if is_invincible: return current_health
	if current_health <= 0: return current_health
	current_health -= attack.attack_damage
	var parent = get_parent()
	if current_health <= 0:
		if parent.has_method("die"): parent.die()
		else: sprite.play("take_damage")
		return current_health
	sprite.play("take_damage")
	print(parent.name + " taking damage")
	sprite.self_modulate = Color("ffffff78")
	is_invincible = true
	iframes_timer.start()
	return current_health
