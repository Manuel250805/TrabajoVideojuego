extends Area2D

var ya_murio: bool = false

func _on_body_entered(body: Node2D) -> void:
	# Verificamos si es el jugador y si no ha muerto ya
	if body.is_in_group("player") and not ya_murio:
		ya_murio = true
		
		# 1. Llamamos a su función de morir
		body.morir()
		
		# 2. CONGELAMOS AL JUGADOR (Evita que caiga o se mueva)
		if body is CharacterBody2D:
			body.velocity = Vector2.ZERO
			body.set_physics_process(false) # Esto detiene su movimiento por completo
		
		# 3. Esperamos el tiempo de la "escena de muerte"
		await get_tree().create_timer(1.5).timeout 
		
		# 4. Reiniciamos
		get_tree().reload_current_scene()
