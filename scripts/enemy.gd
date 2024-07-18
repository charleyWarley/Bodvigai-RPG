extends Entity

var player = null
var home := Vector2.ZERO
var can_attack := false

func _on_detection_area_body_entered(body):
	if body.name == "player" and is_alive:
		player = body


func _on_detection_area_body_exited(body):
	if body.name == "player":
		player = null


func _ready():
	if !is_alive: return
	home = position
	randomize()
	var random_direction = randi_range(1, 3)
	match random_direction:
		1: sprite.play("idle_down")
		2: sprite.play("idle_up")
		3: sprite.play("idle_side")
	randomize()
	random_direction = randi_range(1, 2)
	match random_direction:
		1: sprite.flip_h = false
		2: sprite.flip_h = true


func _physics_process(_delta):
	if !is_alive: return
	if player == null: return
	if weapon.is_attacking: return
	apply_movement()
	check_flip()
	move_and_slide()


func apply_movement():
	if player == null: 
		go_home()
		return
	if player.is_alive: chase_player()
	else: player = null


func chase_player():
	if is_attacking: return
	var target_position = player.position - position
	direction = Vector2(sign(target_position.x), sign(target_position.y))
	position += target_position / speed
	animate("walk")


func go_home():
	if position != home:
		var target_position = home - position
		direction = Vector2(sign(target_position.x), sign(target_position.y))
		position += target_position / speed
		return
	animate("idle")



