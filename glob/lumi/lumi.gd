extends StaticBody2D

const ESCENA_VICTORIA = "res://victoria/victoria.tscn"
const NAME_PLAYER = "Player"
const GROUP_PLAYER = "player"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == NAME_PLAYER or body.is_in_group(GROUP_PLAYER):
		get_tree().change_scene_to_file(ESCENA_VICTORIA)
