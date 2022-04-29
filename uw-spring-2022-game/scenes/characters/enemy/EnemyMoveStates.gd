class_name EnemyMoveStates
extends EnemyKnockbackStates


func _ready() -> void:
	add_state("move")


func _state_logic(delta: float) -> void:
	match state:
		states.move:
			parent.move()
	._state_logic(delta)


func _get_transition(delta: float):
	match state:
		states.idle:
			if parent.move_dir != null:
				return states.move
		states.move:
			if parent.move_dir == null:
				return states.idle
	._get_transition(delta)


func _enter_state(new_state: String, old_state) -> void:
	match new_state:
		states.move:
			parent.play_anim("move")
	._enter_state(new_state, old_state)
