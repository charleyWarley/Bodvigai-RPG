extends Area2D

@export var health_component : HealthComponent

func take_damage(attack: Attack) -> float:
	if !health_component: return 0.0
	return health_component.take_damage(attack)


func check_health() -> int:
	return health_component.current_health
