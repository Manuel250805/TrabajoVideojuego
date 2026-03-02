extends Area2D

const GROUP_PLAYER = "player"

var ya_murio: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(GROUP_PLAYER) and not ya_murio:
		ya_murio = true
		
		body.morir()
		
		if body is CharacterBody2D:
			body.velocity = Vector2.ZERO
			body.set_physics_process(false)
		
		await get_tree().create_timer(1.5).timeout 
		
		get_tree().reload_current_scene()
