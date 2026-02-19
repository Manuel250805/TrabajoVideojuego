extends Node

var coins = 0

func add_coin():
	coins += 1
	# Buscamos la etiqueta en la escena y le cambiamos el texto
	# (Asegúrate de que la ruta sea exactamente donde está tu Label)
	var label = get_tree().root.find_child("ContadorMonedas", true, false)
	if label:
		label.text = "Monedas: " + str(coins)
	
	print("Monedas: ", coins)
