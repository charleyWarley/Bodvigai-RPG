extends Entity

var player = null
var home := Vector2.ZERO
var min_distance := Vector2(1, 15)
var is_chasing := false
@onready var detection_area := $detection_area


func _on_detection_area_body_entered(body):
	if body.name == "player" and is_alive:
		player = body
		is_chasing = true


func _on_detection_area_body_exited(body):
	if body.name == "player":
		player = null
		is_chasing = false


func _ready():
	if !is_alive: 
		is_chasing = false
		return
	home = position
	randomize()
	var random_direction = randi_range(1, 2)
	match random_direction:
		1: direction = Vector2.DOWN
		2: direction = Vector2.UP
	randomize()
	random_direction = randi_range(1, 2)
	match random_direction:
		1: sprite.flip_h = false
		2: sprite.flip_h = true
	check_flip()


func _physics_process(delta):
	#if the enemy isn't alive, has no target, or is attacking, exit method
	if (
		!is_alive or 
		weapon.is_attacking
		): 
			return 
	check_movement(delta)
	check_flip()
	move_and_slide()


func check_movement(delta):
	if weapon.can_attack: return
	if !is_chasing: 
			go_home(delta)
			return
	if player == null: return
	if player.is_alive: chase_player(delta)
	else: player = null


func chase_player(delta):
	if is_attacking: return
	var target_distance = position.distance_to(player.position)
	if target_distance > min_distance.length():
		check_animation("walk", false)
		check_audio("walk", false)
		var target_direction = position.direction_to(player.position)
		velocity = target_direction * speed * delta
	else:
		check_animation("idle", false)
	direction = Vector2(sign(velocity.x), sign(velocity.y))
	

func go_home(delta):
	if weapon.is_attacking or weapon.can_attack or is_chasing:
		weapon.is_attacking = false
		weapon.can_attack = false
		is_chasing = false
		player = null
	if position.distance_to(home) <= min_distance.length():
		velocity = Vector2.ZERO
		check_animation("idle", false)
		return
	var target_direction = position.direction_to(home)
	direction = Vector2(sign(target_direction.x), sign(target_direction.y))
	velocity = target_direction * speed * delta
	check_animation("walk", false)
	check_audio("walk", false)
