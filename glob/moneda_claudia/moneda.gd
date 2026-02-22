extends Area2D


func _ready():
	# Reproducimos la animación cuando está en nuestro mundo
	$ani_moneda.play("default")


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
