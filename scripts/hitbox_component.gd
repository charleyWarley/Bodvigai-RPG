extends Area2D

signal attack_blocked

@export var health_component : HealthComponent
@onready var stun_timer := $stun_timer
var can_block = false

func _on_weapon_attack_state_changed(_is_attacking):
	can_block = _is_attacking


func _process(_delta):
	if check_health() <= 0:
		monitoring = false 


func take_damage(attack: Attack) -> int:
	if can_block:
		var is_block_successful = attempt_block()
		if is_block_successful:
			print("attack blocked")
			emit_signal("attack_blocked")
			return check_health()
	if !health_component: return 0
	get_stunned(attack.stun_time)
	health_component.take_damage(attack)
	return check_health()

func attempt_block() -> bool:
	randomize()
	var random_chance := randi_range(1, 10)
	if random_chance > 7:
		return true
	else:
		return false

func get_stunned(stun_time: float):
	emit_signal("stun_state_changed", true)
	stun_timer.wait_time = stun_time
	stun_timer.start()

	
func check_health() -> int:
	return health_component.current_health
