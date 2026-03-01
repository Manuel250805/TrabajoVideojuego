extends Area2D

var default:String="default"
var player:String="player"
@export var id_moneda: int = 0

func _ready():
	if id_moneda in Global.monedas_recogidas:
		queue_free()  # Ya fue recogida
		return
	$ani_moneda.play(default)

func _on_body_entered(body: Node2D):
	if body.is_in_group(player):
		body.add_moneda()  # Tu función para sumar monedas al jugador
		Global.monedas_recogidas.append(id_moneda)
		queue_free()
