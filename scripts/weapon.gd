extends Node2D

signal attack_state_changed(_is_attacking: bool)


var can_attack := false
var is_attacking := false
var targets := []
var parent = get_parent()
var _attack : Attack = null
@export var target_name : String
@export var cooldown_time := 1.0
@export var attack_damage := 1
@export var knockback_force := 2.0
@export var stun_time := 1.5
@onready var cooldown_timer := $cooldown_timer
@onready var sprite := $"../AnimatedSprite2D"


func _on_hitbox_area_entered(area):
	#if the area entering can't take damage or is already attacking or is dead or the attacker is dead, exit method
	if (!area.has_method("take_damage") or 
	is_attacking or 
	area.check_health() <= 0 or 
	!parent.is_alive
	): 
		return  
	#if the target is in the same group as the attacking entity, exit method
	for group in parent.get_groups(): 
		if area.get_parent().is_in_group(group): return 
	#set the area as the target and allow attack attempts
	targets.append(area)
	can_attack = true


func _on_hitbox_area_exited(area): 
	if !area.has_method("take_damage"): return #if the area exiting can't take damage, exit method
	#clear the target and disallow attack attempts
	targets.erase(area)
	if targets == []: can_attack = false


func _on_cooldown_timer_timeout():
	#when the attack cooldown timer times out, signal the end of the attack
	is_attacking = false
	emit_signal("attack_state_changed", is_attacking)
	for target in targets:
		if !target.get_parent().is_alive: targets.erase(target)
	if targets == []: can_attack = false
	else: can_attack = true


func _ready():
	#set the parent and attack cooldown time, and disallow attack attempts
	parent = get_parent()
	cooldown_timer.wait_time = cooldown_time
	create_attack_node()


func _process(_delta):
	if !parent.is_alive:
		set_process(false)
		return
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
	if ((parent.is_in_group("enemies") and !can_attack) or 
		(parent.is_in_group("players") and is_attacking)
		): return #if the attacker is an enemy and can't attack, exit method
	#disallow attack attempts during current attack, start the attack cooldown timer
	can_attack = false
	cooldown_timer.start()
	#signal and trigger the start of an attack
	is_attacking = true
	parent.check_animation("attack", true)
	emit_signal("attack_state_changed", is_attacking)
	if targets == []: 
		can_attack = false
		return #if there is no target, exit method to avoid trying to deal damage to nothing
	#if the target is dead, clear the target
	var target_health : int
	for target in targets:
		if target.take_damage(_attack) <= 0:
			targets.erase(target)
			can_attack = false
