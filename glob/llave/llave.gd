extends Area2D

const GROUP_PLAYER = "player"
const NAME_PLAYER = "Player"
const SIGNAL_LLAVE = "llave_recogida"
const FUNC_FREE = "queue_free"

signal llave_recogida

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(GROUP_PLAYER) or body.name == NAME_PLAYER:
		emit_signal(SIGNAL_LLAVE)
		call_deferred(FUNC_FREE)
