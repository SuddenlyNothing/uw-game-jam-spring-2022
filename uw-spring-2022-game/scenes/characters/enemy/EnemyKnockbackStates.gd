class_name EnemyKnockbackStates
extends EnemyStates


func _ready() -> void:
	add_state("knockback")


func _state_logic(delta: float) -> void:
	match state:
		states.knockback:
			pass
	._state_logic(delta)


func _get_transition(delta: float):
	match state:
		states.idle:
			if parent.knockback_velocity:
				return states.knockback
		states.knockback:
			if not parent.knockback_velocity:
				return states.knockback
	return ._get_transition(delta)


func _enter_state(new_state: String, old_state) -> void:
	match new_state:
		states.knockback:
			parent.play_anim("knockback")
	._enter_state(new_state, old_state)
