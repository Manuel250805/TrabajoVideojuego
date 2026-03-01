extends CharacterBody2D

@export var speed: float = 100.0
@export var chase_speed: float = 200.0
@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var sentido = 1
var atacando = false

# Nodo del jugador (asegúrate de que el jugador esté en el grupo "jugadores")
@onready var jugador = get_tree().get_first_node_in_group("jugadores")

func _ready() -> void:
	$ani_ene_dyn.play("default")

func _physics_process(delta: float) -> void:
	# 1. Aplicar Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# 2. DETECTAR SI ESTÁ EN LA MISMA PLATAFORMA
	if jugador:
		var diff_y = abs(global_position.y - jugador.global_position.y)
		# Si la diferencia de altura es menor a 30 píxeles, están al mismo nivel
		if diff_y < 30:
			# Mirar hacia donde está el jugador
			if jugador.global_position.x > global_position.x:
				sentido = 1
			else:
				sentido = -1
			atacando = true
		else:
			atacando = false

	# 3. Lógica de patrulla (Solo si no está atacando)
	if not atacando:
		if sentido == 1 and (is_on_wall() or not $detectorDerecho.is_colliding()):
			sentido = -1
		elif sentido == -1 and (is_on_wall() or not $detectorIzquierdo.is_colliding()):
			sentido = 1
		velocity.x = sentido * speed
	else:
		# Si está atacando, va más rápido y no se detiene en los bordes
		velocity.x = sentido * chase_speed
		# Opcional: Si quieres que NO se caiga de la plataforma al atacar, 
		# añade aquí la misma lógica de los detectores.
	
	# 4. Girar el sprite
	$ani_ene_dyn.flip_h = (sentido == -1)


	# 5. Mover
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Solo matamos al jugador si el jugador NO está atacando
		if not body.is_attacking: 
			body.morir()
		
func morir_enemigo():
	queue_free() # Esto elimina al caballero del juego
