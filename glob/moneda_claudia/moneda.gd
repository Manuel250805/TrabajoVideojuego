extends Area2D


func _ready():
	# Reproducimos la animación cuando está en nuestro mundo
	$ani_moneda.play("default")


func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.add_moneda()
		queue_free()
