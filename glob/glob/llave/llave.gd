extends Area2D

signal llave_recogida

func _on_body_entered(body: Node2D) -> void:
	# Nota: Asegúrate de que tu jugador esté en el grupo "player" o se llame "Player"
	if body.is_in_group("player") or body.name == "Player": 
		emit_signal("llave_recogida") 
		call_deferred("queue_free")
