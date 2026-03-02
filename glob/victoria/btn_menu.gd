extends Button

const PATH_ESCENA = "res://menu/control.tscn"

var escena: String = PATH_ESCENA

func _on_pressed() -> void:
	get_tree().change_scene_to_file(escena)

func _on_btn_salir_pressed() -> void:
	get_tree().quit()
