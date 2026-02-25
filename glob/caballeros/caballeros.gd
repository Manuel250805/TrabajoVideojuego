extends CharacterBody2D

@export var speed: float = 100.0
@export var chase_speed: float = 200.0
@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var sentido := 1
var atacando := false

var player_detectado := false
var player: Node2D = null

@onready var anim = $ani_ene_dyn

func _ready():
    anim.play("default")


func _physics_process(delta):
    # Gravedad
    if not is_on_floor():
        velocity.y += gravity * delta
    else:
        velocity.y = 0

    # ============================
    # ATAQUE AUTOMÁTICO
    # ============================
    if player_detectado and player != null:

        # Mirar hacia el jugador
        if player.global_position.x < global_position.x:
            sentido = -1
        else:
            sentido = 1

        # Girar sprite
        $ani_ene_dyn.flip_h = (sentido == -1)

        velocity.x = sentido * chase_speed

        if not atacando:
            atacando = true
            anim.play("atacar")

        move_and_slide()
        return

    # ============================
    # PATRULLA
    # ============================
    if sentido == 1 and (is_on_wall() or not $detectorDerecho.is_colliding()):
        sentido = -1
    elif sentido == -1 and (is_on_wall() or not $detectorIzquierdo.is_colliding()):
        sentido = 1

    velocity.x = sentido * speed

    # Girar sprite
    $ani_ene_dyn.flip_h = (sentido == -1)

    move_and_slide()


func _on_area_2d_body_entered(body):
    if body.is_in_group("jugadores"):
        player_detectado = true
        player = body


func _on_area_2d_body_exited(body):
    if body == player:
        player_detectado = false
        player = null
        atacando = false
        anim.play("default")


func _on_ani_ene_dyn_animation_finished():
    if anim.animation == "atacar":
        if player_detectado and player != null:
            anim.play("atacar")
        else:
            atacando = false
            anim.play("default")


func morir_enemigo():
    queue_free()
