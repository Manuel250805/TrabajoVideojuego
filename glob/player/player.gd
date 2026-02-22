extends CharacterBody2D

@export var speed: float = 250.0
@export var jump_force: float = -450.0
@export var gravity: float = 1000.0

@export var left_limit: float = 0.0
@export var right_limit: float = 1040.0
@export var max_jumps: int = 2

var jump_count: int = 0
var is_attacking: bool = false

@onready var anim = $AnimatedSprite2D

func _physics_process(delta):

	# GRAVEDAD
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0

	# ATAQUE
	if Input.is_action_just_pressed("atacar") and not is_attacking:
		is_attacking = true
		anim.play("attack")
		velocity.x = 0

	# Si está atacando no puede moverse
	if not is_attacking:
		var direction = Input.get_axis("ui_left", "ui_right")
		velocity.x = direction * speed

		if direction != 0:
			anim.flip_h = direction < 0

		# SALTO
		if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
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


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		is_attacking = false
