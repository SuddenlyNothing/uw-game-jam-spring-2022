extends KinematicBody2D

export(int) var idle_friction := 2000

export(int) var walk_max_speed := 100
export(int) var walk_acceleration := 1200
export(int) var walk_friction := 2000

export(int) var trans_max_speed := 200
export(int) var trans_acceleration := 100
export(int) var trans_friction := 800

export(int) var dash_max_speed := 400
export(int) var dash_acceleration := 1200
export(int) var dash_friction := 1200

var velocity := Vector2()
var input := Vector2()
var face_dir := Vector2()

onready var anim_sprite := $Pivot/AnimatedSprite
onready var pivot = $Pivot
onready var player_states := $PlayerStates
onready var state_label := $StateLabel


func _process(delta: float) -> void:
	_get_input()
	_set_face_dir()
	_set_facing()


func move_walk(delta: float) -> void:
	_move_accelerated_within(delta, walk_acceleration, walk_max_speed, walk_friction)
	if velocity.length() >= walk_max_speed and input.dot(velocity.normalized()) > 0.7:
		_apply_acceleration(delta, trans_acceleration)


func move_dash(delta: float) -> void:
	_move_accelerated_within(delta, dash_acceleration, dash_max_speed, dash_friction)


func move_idle(delta: float) -> void:
	_apply_friction(delta, idle_friction)
	_move()


func set_anim(anim_prefix: String) -> void:
	var look_ang: float = face_dir.angle()
	var anim_dir := ""
	match anim_prefix:
		"walk":
			if _is_between(look_ang, -PI / 4, PI / 4) or \
					(look_ang > PI * 3 / 4 or look_ang < -PI * 3 / 4):
				anim_dir = "right"
			elif _is_between(look_ang, -PI * 3 / 4, -PI / 4):
				anim_dir = "up"
			else:
				anim_dir = "down"
		"idle":
			if _is_between(look_ang, -PI / 4, PI / 4) or \
					(look_ang > PI * 3 / 4 or look_ang < -PI * 3 / 4):
				anim_dir = "right"
			elif _is_between(look_ang, -PI * 3 / 4, -PI / 4):
				anim_dir = "up"
			else:
				anim_dir = "down"
	_play_anim(anim_prefix + "_" + anim_dir)


func _move_accelerated(delta: float, acceleration: int, friction: int) -> void:
	_apply_acceleration(delta, acceleration)
	_apply_friction(delta, friction)
	_move()


func _move_accelerated_within(delta: float, acceleration: int, max_speed: int,
			friction: int) -> void:
	_apply_acceleration_within(delta, acceleration, max_speed)
	_apply_friction(delta, friction)
	_move()


func _move() -> void:
	velocity = move_and_slide(velocity)


func _apply_acceleration(delta: float, acceleration: int) -> void:
	velocity += acceleration * delta * input


func _apply_acceleration_within(delta: float, acceleration: int, max_speed: int) -> void:
	var acceleration_amount := acceleration * delta
	if velocity.length() < max_speed or input.dot(velocity.normalized()) < 1:
		velocity += acceleration_amount * velocity.direction_to(input * max_speed)


func _apply_friction(delta: float, friction: int) -> void:
#	if input != Vector2():
#		return
	if input.dot(velocity.normalized()) > 0:
		return
	var friction_amount := friction * delta
	if velocity.length() <= friction_amount:
		velocity = Vector2()
	else:
		velocity -= friction_amount * velocity.normalized()


func _get_input() -> void:
	input = Input.get_vector("left", "right", "up", "down")


func _set_face_dir() -> void:
	face_dir = get_local_mouse_position().normalized()


func _set_facing() -> void:
	if (face_dir.x < 0 and pivot.scale.x > 0) or\
			(face_dir.x > 0 and pivot.scale.x < 0):
		pivot.scale.x *= -1


func _play_anim(anim: String) -> void:
	if anim_sprite.animation == anim and anim_sprite.playing:
		return
	anim_sprite.play(anim)


func _is_between(check_val: float, min_v: float, max_v: float) -> bool:
	return (check_val >= min_v and check_val <= max_v)
