extends Area2D

@export var health_component : HealthComponent

func take_damage(attack: Attack) -> int:
	if !health_component: return 0
	health_component.take_damage(attack)
	return check_health()


func check_health() -> int:
	return health_component.current_health
