extends Area

var damage = 20

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	# print("Столкновение с " + body.name)
	if body.has_method("take_damage"):
		# print("Нанесен урон")
		body.take_damage(damage)
