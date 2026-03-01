extends Button

var escena:String="res://mazmorra-rocosa/mazmorra_rocosa.tscn"
func _on_pressed() -> void:
	get_tree().change_scene_to_file(escena)


func _on_btn_salir_pressed() -> void:
	get_tree().quit()  # Esto cierra el juego
