extends CharacterBody2D

const GROUP_PLAYER = "player"
const GROUP_ENEMIES = "enemigos"
const ACTION_ATTACK = "atacar"
const ACTION_LEFT = "izquierda"
const ACTION_RIGHT = "derecha"
const ACTION_JUMP = "saltar"
const ANIM_ATTACK = "attack"
const ANIM_JUMP = "jump"
const ANIM_RUN = "run"
const ANIM_IDLE = "idle"
const ANIM_DIE = "morir"
const METHOD_DIE_ENEMY = "morir_enemigo"
const PROP_DISABLED = "disabled"

@export var speed: float = 250.0
@export var jump_force: float = -450.0
@export var gravity: float = 1000.0
@export var left_limit: float = 0.0
@export var right_limit: float = 1040.0
@export var max_jumps: int = 2

var jump_count: int = 0
var is_attacking: bool = false
var esta_muerto: bool = false

@onready var anim = $ani_player
@onready var contador: Control = $CanvasLayer/Contador
static var monedas = 0

func _ready() -> void:
    add_to_group(GROUP_PLAYER)
    if contador:
        contador.actualizar(monedas)

func _physics_process(delta):
    if esta_muerto:
        return

    # Gravedad
    if not is_on_floor():
        velocity.y += gravity * delta
    else:
        jump_count = 0

    # Ataque
    if Input.is_action_just_pressed(ACTION_ATTACK) and not is_attacking:
        is_attacking = true
        anim.play(ANIM_ATTACK)
        velocity.x = 0
        $area_golpe2/col_golpe.disabled = false

    # Movimiento
    if not is_attacking:
        var direction = Input.get_axis(ACTION_LEFT, ACTION_RIGHT)
        velocity.x = direction * speed

        if direction != 0:
            anim.flip_h = direction < 0

        if Input.is_action_just_pressed(ACTION_JUMP) and jump_count < max_jumps:
            velocity.y = jump_force
            jump_count += 1

        if not is_on_floor():
            anim.play(ANIM_JUMP)
        elif direction != 0:
            anim.play(ANIM_RUN)
        else:
            anim.play(ANIM_IDLE)

    move_and_slide()
    position.x = clamp(position.x, left_limit, right_limit)

func _on_animated_sprite_2d_animation_finished() -> void:
    if anim.animation == ANIM_ATTACK:
        is_attacking = false
        $area_golpe2/col_golpe.disabled = true

func _on_area_golpe_2_body_entered(body: Node2D) -> void:
    if esta_muerto:
        return

    if is_attacking and body.is_in_group(GROUP_ENEMIES):
        if body.has_method(METHOD_DIE_ENEMY):
            body.morir_enemigo()

func add_moneda():
    monedas += 1
    contador.actualizar(monedas)

func morir():
    if esta_muerto:
        return

    esta_muerto = true
    is_attacking = false
    velocity = Vector2.ZERO

    # Desactivar colisiones
    $col_player.set_deferred(PROP_DISABLED, true)
    $area_golpe2/col_golpe.set_deferred(PROP_DISABLED, true)

    anim.play(ANIM_DIE)

    $tiempo.start()
    await $tiempo.timeout
    get_tree().reload_current_scene()
