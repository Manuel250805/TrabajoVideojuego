extends CharacterBody2D
var default:String="default"
var jugadores:String="jugadores"
var physics:String="physics/2d/default_gravity"
var player:String="player"
@export var speed: float = 100.0
@export var chase_speed: float = 200.0
@onready var gravity: float = ProjectSettings.get_setting(physics)
var sentido = 1
var atacando = false
@onready var jugador = get_tree().get_first_node_in_group(jugadores)

func _ready() -> void:
	$ani_ene_dyn.play(default)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if jugador:
		var diff_y = abs(global_position.y - jugador.global_position.y)
		if diff_y < 30:
			if jugador.global_position.x > global_position.x:
				sentido = 1
			else:
				sentido = -1
			atacando = true
		else:
			atacando = false

	if not atacando:
		if sentido == 1 and (is_on_wall() or not $detectorDerecho.is_colliding()):
			sentido = -1
		elif sentido == -1 and (is_on_wall() or not $detectorIzquierdo.is_colliding()):
			sentido = 1
		velocity.x = sentido * speed
	else:
		velocity.x = sentido * chase_speed
	$ani_ene_dyn.flip_h = (sentido == -1)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(player):
		if not body.is_attacking: 
			body.morir()
		
func morir_enemigo():
	queue_free()
