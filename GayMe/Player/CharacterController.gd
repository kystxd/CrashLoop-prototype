extends KinematicBody  
  
# НАСТРОЙКИ ПЕРСОНАЖА!!!!!!!1   
var velocity = Vector3()  
var gravity = -20 # гравитация жиесть брат  
var jump_speed = 6   
var speed = 8 # поднял скорость, так как 2 для 3D маловато
var mouse_sensitivity = 0.002 # сенса мышки  
var is_paused = false # булин для паузы  
var pause_menu = null  
var max_hp = 100 # максимальное кол-во хп у игрока  
var current_hp = 100 # текущее кол-во хп у игрока  
var is_dead = false  

onready var pivot = $CameraPivot
onready var spring_arm = $CameraPivot/SpringArm

# ------------------------------------------------------------------------------------------ #  
  
func _ready():  
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  
	update_hp_ui()  
  
func _physics_process(delta):  
	if is_paused or is_dead:  
		return  
   
	var input_dir = Vector3()  
  
	# управлениее!! шок кл таблеточка двигаться!!!  
	if Input.is_key_pressed(KEY_W): # бинд передвижения на W  
		input_dir.z -= 1  
	if Input.is_key_pressed(KEY_A): # бинд передвижения на A  
		input_dir.x -= 1  
	if Input.is_key_pressed(KEY_S): # бинд передвижения на S  
		input_dir.z += 1  
	if Input.is_key_pressed(KEY_D): # бинд передвижения на D  
		input_dir.x += 1  
  
	input_dir = input_dir.normalized()  

	# Считаем направление движения относительно поворота камеры (pivot)
	var direction = (pivot.transform.basis * input_dir).normalized()  
   
	# движение по XZ  
	velocity.x = direction.x * speed  
	velocity.z = direction.z * speed  
  
	# гравитация  
	velocity.y += gravity * delta  
  
	# я джампер, моя профессия прыгать   
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):  
		velocity.y = jump_speed  
  
	velocity = move_and_slide(velocity, Vector3.UP)  
  
func _input(event):  
	if event is InputEventKey:  
		if event.scancode == KEY_ESCAPE and event.pressed:  
			if is_paused:  
				resume_game()  
			else:  
				pause_game()  
   
	if is_paused or is_dead:  
		return  
   
	if event is InputEventMouseMotion and has_node("CameraPivot/SpringArm"):  
		# Вращаем pivot влево-вправо
		pivot.rotate_y(-event.relative.x * mouse_sensitivity)  
  
		# Вращаем SpringArm вверх-вниз
		spring_arm.rotate_x(-event.relative.y * mouse_sensitivity)  
		
		# Ограничиваем наклон камеры по вертикали
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -70, 50)  

func _process(delta):  
	pass  

func take_damage(amount):  
	if is_dead:  
		return  
   
	current_hp -= amount  
	current_hp = max(current_hp, 0)  
	update_hp_ui()  
   
	if current_hp <= 0:  
		die()  

func heal(amount):  
	if is_dead:  
		return  
   
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
