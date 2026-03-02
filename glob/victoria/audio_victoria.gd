extends AudioStreamPlayer2D

const SIGNAL_FINISHED = "finished"
const FUNC_STOP = "stop"
const FUNC_FREE = "queue_free"
const TIEMPO_CORTE = 4.1

func _ready() -> void:
	stop()
	var timer = get_tree().create_timer(TIEMPO_CORTE)
	timer.timeout.connect(_on_timer_timeout)
	play()

func _on_timer_timeout() -> void:
	stop()
	call_deferred(FUNC_FREE)

func _on_finished() -> void:
	stop()
