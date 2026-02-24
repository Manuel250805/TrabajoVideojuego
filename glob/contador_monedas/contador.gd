extends Control

func actualizar(monedas: int):
	# Ahora llamamos directamente al Label porque ya no está dentro del HBox
	$lbl_contador_mon.text = str(monedas)
