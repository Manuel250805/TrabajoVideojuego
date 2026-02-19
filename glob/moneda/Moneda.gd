extends Area2D

func _on_body_entered(body):
	# Verificamos si es el jugador el que toca la moneda
	if body is CharacterBody2D:
		GameManager.add_coin() # Esto usa el Autoload que configuramos
		queue_free()           # Borra la moneda al tocarla
