extends Node2D

signal attack_state_changed(bool)

var attack_damage := 1.0
var knockback_force := 2.0
var stun_time := 1.5
var can_attack := false
var is_attacking := false
var target : Area2D = null
var parent = get_parent()
var _attack : Attack = null
@export var target_name : String
@export var cooldown_time := 1.0
@onready var cooldown_timer := $cooldown_timer
@onready var sprite := $"../AnimatedSprite2D"


func _on_hitbox_area_entered(area):
	if !area.has_method("take_damage") or is_attacking: return  #if the area entering can't take damage or is already attacking, exit method
	for group in parent.get_groups(): if area.get_parent().is_in_group(group): return #if the target is in the same group as the attacking entity, exit method
	#if all above cases pass through, set the area as the target and allow attack attempts
	target = area
	can_attack = true


func _on_hitbox_area_exited(area): 
	if !area.has_method("take_damage"): return #if the area exiting can't take damage, exit method
	#clear the target and disallow attack attempts
	target = null
	can_attack = false


func _on_cooldown_timer_timeout():
	#when the attack cooldown timer times out, signal the end of the attack
	is_attacking = false
	emit_signal("attack_state_changed", is_attacking)
	if target == null: return #if the target  has been cleared, exit method 
	#allow another attack attempt
	can_attack = true


func _ready():
	#set the parent and attack cooldown time, and disallow attack attempts
	parent = get_parent()
	cooldown_timer.wait_time = cooldown_time
	create_attack_node()


func _process(_delta):
	#if the entity can't attack, exit method
	#if the entity, check for input before attempting an attack
	if parent.name == "player":
		if Input.is_action_just_pressed("attack"):
			attack()
			return
		return
	if can_attack: attack() #if the entity is not the player and the entity can attack, attempt an attack


func create_attack_node():
	_attack = Attack.new()
	_attack.attack_damage = attack_damage
	_attack.attack_position = position
	_attack.stun_time = stun_time


func attack():
	if !can_attack: return #if the player can't attack, exit method
	#disallow attack attempts during current attack, start the attack cooldown timer
	can_attack = false
	cooldown_timer.start()
	#signal the start of an attack
	is_attacking = true
	emit_signal("attack_state_changed", is_attacking)
	if target == null: return #if there is no target, exit method to avoid trying to deal damage to nothing
	animate_attack()
	var target_health = target.take_damage(_attack)
	if target_health <= 0: target = null


func animate_attack():
	if parent.direction.x != 0: sprite.play("attack_side")
	elif parent.direction.y > 0: sprite.play("attack_down")
	elif parent.direction.y < 0: sprite.play("attack_up")
	randomize()
	var random_index = randi_range(1, 10)
	parent.check_audio("attack" + str(random_index), true)
