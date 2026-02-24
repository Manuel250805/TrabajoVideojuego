extends StaticBody2D

func _ready():
	var camara = $Player/Camera2D
	
	camara.limit_left = 0
	camara.limit_right = 1150
	camara.limit_bottom = 650
	camara.limit_top = -650

func _on_screen_exited():
	get_tree().reload_current_scene() # Reinicia si se sale de la vista de la cámara
