extends Area2D

@export_file("*.tscn") var siguiente_escena

# 1. Creamos una variable para saber si la llave ya se recogió
var tiene_llave : bool = false

# Esta función se ejecutará cuando la SEÑAL de la llave llegue aquí
func _on_llave_llave_recogida():
	# 2. Marcamos que ya tenemos la llave y abrimos la animación
	tiene_llave = true
	$puerta_anim.play("abrir")

# Esta función es para cuando el jugador ENTRA en la puerta
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# 3. Solo cambiamos de escena SI tiene la llave
		if tiene_llave:
			if siguiente_escena != "":
				get_tree().change_scene_to_file(siguiente_escena)
			else:
				print("¡Error! Te olvidaste de elegir la escena en el Inspector.")
		else:
			# Opcional: puedes imprimir un mensaje o hacer un sonido de "cerrado"
			print("La puerta está cerrada, necesitas la llave.")
