extends KinematicBody

var velocity = Vector3()
var gravity = -20
var jump_speed = 9
var speed = 4
var is_paused = false
var pause_menu = null
var max_hp = 300
var current_hp = 100
var is_dead = false

func _ready():
	update_hp_ui()

func _physics_process(delta):
	if is_paused or is_dead:
		return

	var input_dir = Vector3()

	if Input.is_key_pressed(KEY_W):
		input_dir.z -= 1
	if Input.is_key_pressed(KEY_A):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.z += 1
	if Input.is_key_pressed(KEY_D):
		input_dir.x += 1

	input_dir = input_dir.normalized()

	var direction = ($CameraPivot.transform.basis * input_dir).normalized()
	direction.y = 0

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = jump_speed

	velocity = move_and_slide(velocity, Vector3.UP)

	if Input.is_key_pressed(KEY_W):
		input_dir.z -= 1
	if Input.is_key_pressed(KEY_A):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.z += 1
	if Input.is_key_pressed(KEY_D):
		# D — движение вправо.
		input_dir.x += 1

	input_dir = input_dir.normalized()

	direction.y = 0
	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	if not is_on_floor():
		velocity.y += gravity * delta

	else:
		velocity.y = 0

		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = jump_speed
	velocity = move_and_slide(velocity, Vector3.UP)

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE and event.pressed:

			if is_paused:
				resume_game()

			else:
				pause_game()


func take_damage(amount):
	if is_dead:
		return

	current_hp -= amount
	current_hp = max(current_hp, 0)
	update_hp_ui()
	if current_hp <= 0:

func heal(amount):
	if is_dead:
	current_hp += amount
	current_hp = min(current_hp, max_hp)
	update_hp_ui()

func die():
	is_dead = true
	print("Игрок умер!")

	var timer = Timer.new()
	timer.wait_time = 1.0
	
	timer.one_shot = true

	add_child(timer)
	timer.connect("timeout", self, "restart_scene")
	timer.start()

func restart_scene():
	get_tree().reload_current_scene()

func update_hp_ui():
	var ui = get_parent().get_node_or_null("UI")
	if ui:
		var hp_bar = ui.get_node_or_null("HPBar")
		if hp_bar:
			hp_bar.max_value = max_hp
			hp_bar.value = current_hp


func pause_game():
	is_paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print("Пауза")

func resume_game():
	is_paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("Продолжить")