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
	if !horizontal_input and !vertical_input: 
		animate("idle")
		return
	animate("walk")
	move_and_slide()



