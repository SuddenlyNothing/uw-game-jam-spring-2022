extends StateMachine


func _ready() -> void:
	add_state("idle")
	add_state("death")
	call_deferred("set_state", "idle")


func _state_logic(delta: float) -> void:
	match state:
		states.idle:
			pass
		states.death:
			pass


func _get_transition(delta: float):
	match state:
		states.idle:
			pass
		states.death:
			pass
	return null


func _enter_state(new_state: String, old_state) -> void:
	match new_state:
		states.idle:
			parent.play_anim("idle")
		states.death:
			parent.play_anim("death")
			parent.disable_collision()


func _exit_state(old_state, new_state: String) -> void:
	match old_state:
		states.idle:
			pass
		states.death:
			pass
