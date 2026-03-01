extends CharacterBody2D

@export var speed: float = 250.0
@export var jump_force: float = -450.0
@export var gravity: float = 1000.0

@export var left_limit: float = 0.0
@export var right_limit: float = 1040.0
@export var max_jumps: int = 2
var jump_count: int = 0
var is_attacking: bool = false

@onready var anim = $ani_player
@onready var contador: Control = $CanvasLayer/Contador
static var monedas = 0

func _ready() -> void:
	add_to_group("player")
	if contador:
		contador.actualizar(monedas)
func _physics_process(delta):
	# 1. GRAVEDAD
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0

	# 2. ATAQUE (Corregido el espacio a la izquierda)
	if Input.is_action_just_pressed("atacar") and not is_attacking:
		is_attacking = true
		anim.play("attack")
		velocity.x = 0
		$area_golpe2/col_golpe.disabled = false

	# 3. MOVIMIENTO (Solo si no está atacando)
	if not is_attacking:
		var direction = Input.get_axis("izquierda", "derecha")
		velocity.x = direction * speed

		if direction != 0:
			anim.flip_h = direction < 0

		# SALTO
		if Input.is_action_just_pressed("saltar") and jump_count < max_jumps:
			velocity.y = jump_force
			jump_count += 1

		# Animaciones normales
		if not is_on_floor():
			anim.play("jump")
		elif direction != 0:
			anim.play("run")
		else:
			anim.play("idle")

	move_and_slide()
	position.x = clamp(position.x, left_limit, right_limit)

# Unificamos la función de fin de animación
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		is_attacking = false
		$area_golpe2/col_golpe.disabled = true # Desactiva el golpe

# --- SEÑAL DE GOLPE AL CABALLERO ---
# Cambiamos el nombre para que coincida con el nodo 'area_golpe2'
func _on_area_golpe_2_body_entered(body: Node2D) -> void:
	if is_attacking and body.is_in_group("enemigos"):
		if body.has_method("morir_enemigo"):
			body.morir_enemigo()

# --- OTROS ---
func add_moneda():
	monedas += 1
	contador.actualizar(monedas)

func morir():
	is_attacking = true 
	velocity.x = 0
	$ani_player.play("morir") 
	$tiempo.start()
	await $tiempo.timeout
	get_tree().reload_current_scene()
