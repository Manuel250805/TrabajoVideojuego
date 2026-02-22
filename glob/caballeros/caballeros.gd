extends CharacterBody2D

@export var speed = 100.0
@onready var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var sentido = 1

func _ready() -> void:
	$ani_ene_dyn.play("default")

func _physics_process(delta: float) -> void:
	# 1. Aplicar Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0 # Limpiamos la velocidad vertical al pisar suelo

	# 2. Lógica de giro corregida
	# Si voy a la DERECHA (1) y choco con pared O el detector DERECHO no toca suelo
	if sentido == 1 and (is_on_wall() or not $detectorDerecho.is_colliding()):
		sentido = -1
	# Si voy a la IZQUIERDA (-1) y choco con pared O el detector IZQUIERDO no toca suelo
	elif sentido == -1 and (is_on_wall() or not $detectorIzquierdo.is_colliding()):
		sentido = 1

	# 3. Aplicar velocidad horizontal
	velocity.x = sentido * speed
	
	# 4. Girar el sprite
	$ani_ene_dyn.flip_h = (sentido == -1)

	# 5. Mover
	move_and_slide()

func _on_ene_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		get_tree().reload_current_scene()
