extends Entity

const SPEED := 3000

func _ready():
	Global.player = self
	print("player created")


func _physics_process(delta):
	if !is_alive: return
	check_flip()
	if weapon.is_attacking: 
		return
	apply_movement(delta)


func apply_movement(delta):
	var horizontal_input = Input.get_axis("move_left", "move_right")
	var vertical_input = Input.get_axis("move_up", "move_down")
	var input_vector = Vector2(horizontal_input, vertical_input).normalized()
	if input_vector != Vector2.ZERO: direction = input_vector
	velocity = input_vector * SPEED * delta
	animate_walk(horizontal_input, vertical_input)
	move_and_slide()


func animate_walk(horizontal_input, vertical_input):
	if !horizontal_input and !vertical_input: 
		if direction.x != 0: sprite.play("idle_side")
		elif direction.y == 1: sprite.play("idle_down")
		elif direction.y == -1: sprite.play("idle_up")
		return
	if horizontal_input != 0: sprite.play("walk_side")
	elif vertical_input == 1: sprite.play("walk_down")
	elif vertical_input == -1: sprite.play("walk_up")


func _on_weapon_attack_state_chanaged(_is_attacking: bool):
	is_attacking = _is_attacking
