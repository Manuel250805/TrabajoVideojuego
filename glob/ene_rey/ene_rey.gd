extends CharacterBody2D

const ANIM_DEFAULT = "run"
const GROUP_PLAYER = "player"
const SETTING_GRAVITY = "physics/2d/default_gravity"
const ANIM_MORIR = "died"
const ANIM_ATACAR = "attack"
const VAR_IS_ATTACKING = "is_attacking"
const PROP_MONITORING = "monitoring"

@export var speed: float = 100.0
@onready var gravity: float = ProjectSettings.get_setting(SETTING_GRAVITY)

var sentido = 1
var atacando = false
var puede_atacar = true

@onready var cuerpo = $Cuerpo
@onready var sprite = $Cuerpo/ani_ene_rey

func _ready() -> void:
    sprite.play(ANIM_DEFAULT)

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += gravity * delta
    else:
        velocity.y = 0

    if not atacando:
        if is_on_wall() or not $Cuerpo/detectorDerecho.is_colliding():
            sentido *= -1

        velocity.x = sentido * speed

        if sprite.animation != ANIM_DEFAULT:
            sprite.play(ANIM_DEFAULT)
    else:
        velocity.x = 0

    cuerpo.scale.x = sentido
    move_and_slide()

func _on_area_ene_rey_body_entered(body: Node2D) -> void:
    if body.is_in_group(GROUP_PLAYER):
        if body.get(VAR_IS_ATTACKING) == true:
            morir_enemigo()
        else:
            if puede_atacar and not atacando:
                sentido = 1 if body.global_position.x > global_position.x else -1
                iniciar_ataque(body)

func iniciar_ataque(objetivo: Node2D):
    atacando = true
    puede_atacar = false
    sprite.play(ANIM_ATACAR)

    await get_tree().create_timer(0.5).timeout

    if sprite.animation != ANIM_MORIR and is_instance_valid(objetivo):
        objetivo.morir()

    ataque_finaliza()

func ataque_finaliza() -> void:
    await get_tree().create_timer(0.4).timeout
    atacando = false

    await get_tree().create_timer(1.0).timeout
    puede_atacar = true

func morir_enemigo():
    if sprite.animation == ANIM_MORIR:
        return

    velocity = Vector2.ZERO
    atacando = true
    set_physics_process(false)

    $Cuerpo/area_ene_rey.set_deferred(PROP_MONITORING, false)

    sprite.play(ANIM_MORIR)

    await get_tree().create_timer(2.0).timeout
    queue_free()
