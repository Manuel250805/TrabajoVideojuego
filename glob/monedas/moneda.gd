extends Area2D

const ANIM_DEFAULT = "default"
const GROUP_PLAYER = "player"

@export var id_moneda: int = 0

func _ready():
	if id_moneda in Global.monedas_recogidas:
		queue_free()
		return
	$ani_moneda.play(ANIM_DEFAULT)

func _on_body_entered(body: Node2D):
	if body.is_in_group(GROUP_PLAYER):
		body.add_moneda()
		Global.monedas_recogidas.append(id_moneda)
		queue_free()
