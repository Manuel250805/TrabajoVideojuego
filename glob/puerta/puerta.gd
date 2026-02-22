extends Area2D
# Puedes elegir la escena desde el inspector de Godot
@export_file("*.tscn") var siguiente_escena

func _on_body_entered(body):
	# Comprobamos si lo que entró es el jugador
	if body is CharacterBody2D:
		# Aquí puedes activar tu animación de la puerta abriéndose
		# $AnimatedSprite2D.play("abrir") 
		
		# Cambiar a la siguiente escena
		if siguiente_escena != "":
			get_tree().change_scene_to_file(siguiente_escena)
		else:
			print("No has asignado una escena en el inspector")
