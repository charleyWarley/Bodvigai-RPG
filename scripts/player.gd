extends Entity

var horizontal_input : float
var vertical_input : float

func _ready():
	#set the player variable of the global script Global to self
	Global.player = self


func _physics_process(delta):
	if !is_alive: return #if the player is dead, exit method
	check_flip() #check the direction of the animated sprite's horizontal flip
	if weapon.is_attacking: return #if the player's weapon is mid-attack, exit method
	#get the player's input and allow movement
	get_player_input()
	apply_movement(delta)


func get_player_input():
	#set the input variables based on the direction inputs
	horizontal_input = Input.get_axis("move_left", "move_right")
	vertical_input = Input.get_axis("move_up", "move_down")
	
	
func apply_movement(delta):
	var input_vector = Vector2(horizontal_input, vertical_input).normalized()
	if input_vector != Vector2.ZERO: direction = input_vector
	velocity = input_vector * speed * delta
	if !horizontal_input and !vertical_input: 
		if weapon.can_attack: check_animation("attack_idle", false)
		else: check_animation("idle", false)
		return
	check_animation("walk", false)
	check_audio("walk", false)
	move_and_slide()
