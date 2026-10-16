extends Spatial

var mouse_sensitivity = 0.002

onready var spring_arm = $SpringArm

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		spring_arm.rotate_x(-event.relative.y * mouse_sensitivity)

		spring_arm.rotation_degrees.x = clamp(
			spring_arm.rotation_degrees.x,
			-70,
			50
		)
