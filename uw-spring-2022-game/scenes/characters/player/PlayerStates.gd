extends StateMachine


func _ready() -> void:
	add_state("idle")
	add_state("walk")
	add_state("dash")
	add_state("death")
	call_deferred("set_state", "idle")


# Contains state logic.
func _state_logic(delta: float) -> void:
	match state:
		states.idle:
			parent.move_idle(delta)
			parent.set_anim("idle")
		states.walk:
			parent.move_walk(delta)
			parent.set_anim("walk")
		states.dash:
			parent.move_dash(delta)
			parent.set_anim("walk")


# Return value will be used to change state.
func _get_transition(delta: float):
	match state:
		states.idle:
			if parent.input != Vector2():
				return states.walk
		states.walk:
			if parent.velocity == Vector2() and parent.input == Vector2():
				return states.idle
			if parent.velocity.length() > parent.trans_max_speed:
				return states.dash
		states.dash:
			if parent.velocity.length() <= parent.walk_max_speed:
				return states.walk
	return null


# Called on entering state.
# new_state is the state being entered.
# old_state is the state being exited.
func _enter_state(new_state: String, old_state) -> void:
	match state:
		states.idle:
			pass
		states.walk:
			pass
		states.dash:
			pass


# Called on exiting state.
# old_state is the state being exited.
# new_state is the state being entered.
func _exit_state(old_state, new_state: String) -> void:
	match state:
		states.idle:
			pass
		states.walk:
			parent.walk_speed = 0
		states.dash:
			pass


func set_dashing(val: bool) -> void:
	if val:
		call_deferred("set_state", "dash")
	elif parent.input != Vector2():
		call_deferred("set_state", "walk")
	else:
		call_deferred("set_state", "idle")


# Sets state while calling _exit_state and _enter_state
# If you want to call this method use call_deferred.
func set_state(new_state: String) -> void:
	parent.state_label.text = new_state
	.set_state(new_state)
