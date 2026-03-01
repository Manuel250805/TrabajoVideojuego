extends CharacterBody2D

var atacando : bool = false
var esta_muerto : bool = false
@onready var jugador = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	$ani_ene_rey.play("run")

func _on_area_ene_rey_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.is_attacking:
			morir_enemigo()
		else:
			body.morir()

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@export var speed = 100
@export var rango_ataque = 150 # Distancia para empezar a atacar

var sentido = 1

func _physics_process(delta: float) -> void:
	if esta_muerto:
		return 

	# --- BLOQUE DE ATAQUE ---
	detectar_jugador()
	# ------------------------

	# 1. Gravedad
	velocity.y += gravity * delta
	
	# 2. Lógica de giro (Pared o Abismo)
	if is_on_wall() or (sentido == 1 and not $detectorIzquierdo.is_colliding()) or (sentido == -1 and not $detectorDerecho.is_colliding()):
		sentido = -sentido

	# 3. Aplicar movimiento y animación
	if atacando:
		velocity.x = 0
		$ani_ene_rey.play("attack")
	else:
		velocity.x = sentido * speed
		$ani_ene_rey.play("run")
		$ani_ene_rey.flip_h = (sentido == -1)

	move_and_slide()

# --- FUNCIÓN DE DETECCIÓN CORREGIDA ---
func detectar_jugador():
	# 1. Verificamos que 'jugador' exista antes de hacer nada
	if is_instance_valid(jugador):
		var distancia = global_position.distance_to(jugador.global_position)
		var misma_altura = abs(global_position.y - jugador.global_position.y) < 50
		var jugador_enfrente = false
		
		if (sentido == 1 and jugador.global_position.x > global_position.x) or (sentido == -1 and jugador.global_position.x < global_position.x):
			jugador_enfrente = true

		if distancia < rango_ataque and misma_altura and jugador_enfrente:
			atacando = true
		else:
			atacando = false
	else:
		# 2. Si es Nil, intentamos buscarlo de nuevo en el grupo
		jugador = get_tree().get_first_node_in_group("player")
		atacando = false # Si no hay jugador, no podemos estar atacando

func morir_enemigo():
	if esta_muerto: return
	esta_muerto = true 
	velocity = Vector2.ZERO
	
	# Desactivamos colisiones para que no moleste al morir
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	$area_ene_rey.set_deferred("monitoring", false)
	
	$ani_ene_rey.play("died")
	# Si por alguna razón la animación no avisa que terminó, 
	# ponemos un timer de seguridad para borrarlo
	await get_tree().create_timer(1.5).timeout
	if is_instance_valid(self):
		queue_free()
