class_name EnemyShootStates
extends EnemyStrafeStates


func _ready() -> void:
	add_state("attack")


func _get_transition(delta: float):
	match state:
		states.move:
			if parent.shot_delay_timer.is_stopped():
				return states.attack
	return _get_transition(delta)


func _enter_state(new_state: String, old_state) -> void:
	match new_state:
		states.move:
			parent.start_shot_delay()
		states.attack:
			parent.set_projectile_dir()
			parent.play_anim("attack")
	._enter_state(new_state, old_state)
