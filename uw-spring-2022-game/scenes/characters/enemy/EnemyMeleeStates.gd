class_name EnemyMeleeStates
extends EnemyAggroStates


func _ready() -> void:
	add_state("attack")


func _get_transition(delta: float):
	match state:
		states.move:
			if parent.is_player_in_hitbox():
				return states.attack
	return ._get_transition(delta)


func _enter_state(new_state: String, old_state) -> void:
	match new_state:
		states.attack:
			parent.play_anim("attack")
	._enter_state(new_state, old_state)
