extends Node
class_name Ability

export(String) var ability_name = "ability"
export(float) var cooldown = 1.0

var is_ready: bool = true
var timer: Timer

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)

func cast():
	if not is_ready:
		print(ability_name, " cooldown!!")
		return false
	
	is_ready = false
	timer.start(cooldown)
	use_ability()
	return true

func use_ability():
	pass

func _on_timer_timeout():
	is_ready = true
	print(ability_name, " ready")

