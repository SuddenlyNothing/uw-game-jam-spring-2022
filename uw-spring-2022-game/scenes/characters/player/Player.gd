extends KinematicBody2D

export(int) var min_light_scale := 1
export(int) var max_light_scale := 4
export(int) var light_lerp := 5

export(int) var idle_friction := 2000

export(int) var walk_max_speed := 100
export(int) var walk_friction := 1000

export(int) var trans_max_speed := 200
export(int) var trans_acceleration := 50

export(int) var dash_max_speed := 400
export(int) var dash_acceleration := 1200
export(int) var dash_friction := 800

var walk_speed: float = 0

var velocity := Vector2()
var input := Vector2()
var face_dir := Vector2()
var desired_light_scale := Vector2.ONE

onready var anim_sprite := $Pivot/AnimatedSprite
onready var pivot = $Pivot
onready var player_states := $PlayerStates
onready var state_label := $StateLabel
onready var m_light_mask := $Light2DMask
onready var m_light_add := $Light2DAdd
onready var fire_particles := $FireViewport/FireParticles


func _process(delta: float) -> void:
	_get_input()
	_set_face_dir()
	_set_facing()
	_set_light_range(delta)


func hit(damage: int, dir: Vector2) -> void:
	prints("player got hit for", damage, "damage")


func move_walk(delta: float) -> void:
	if not input:
		walk_speed = 0
		_apply_friction(delta, walk_friction)
	elif walk_speed < walk_max_speed:
		walk_speed = walk_max_speed
		velocity = walk_speed * input
	elif Input.is_action_pressed("dash"):
		walk_speed += trans_acceleration * delta
		velocity = walk_speed * input
	elif walk_speed > walk_max_speed:
		walk_speed = walk_max_speed
	else:
		velocity = walk_speed * input
	_move(delta)


func move_dash(delta: float) -> void:
	if not Input.is_action_pressed("dash"):
		_apply_friction(delta, dash_friction)
		_move(delta)
	else:
		_move_accelerated_within(delta, dash_acceleration, dash_max_speed, dash_friction)


func move_idle(delta: float) -> void:
	_apply_friction(delta, idle_friction)
	_move(delta)


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
	if input:
		_apply_acceleration(delta, acceleration)
	else:
		_apply_friction(delta, friction)
	_move(delta)


func _move_accelerated_within(delta: float, acceleration: int, max_speed: int,
			friction: int) -> void:
	if input:
		_apply_acceleration_within(delta, acceleration, max_speed)
	else:
		_apply_friction(delta, friction)
	_move(delta)


func _move(delta: float) -> void:
	velocity = move_and_slide(velocity)
	fire_particles.position += velocity * delta


func _apply_acceleration(delta: float, acceleration: int) -> void:
	velocity += acceleration * delta * input


func _apply_acceleration_within(delta: float, acceleration: int, max_speed: int) -> void:
	var acceleration_amount := acceleration * delta
	if velocity.distance_to(input * max_speed) < acceleration_amount:
		velocity = input * max_speed
	else:
		velocity += acceleration_amount * velocity.direction_to(input * max_speed)


func _apply_friction(delta: float, friction: int) -> void:
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


func _set_light_range(delta: float) -> void:
	desired_light_scale = Vector2.ONE * max(range_lerp(velocity.length(), walk_max_speed,
			dash_max_speed, min_light_scale, max_light_scale), min_light_scale)
	var new_scale = lerp(m_light_add.scale, desired_light_scale, clamp(light_lerp * delta, 0, 1))
	m_light_add.scale = new_scale
	m_light_mask.scale = new_scale


func _play_anim(anim: String) -> void:
	if anim_sprite.animation == anim and anim_sprite.playing:
		return
	anim_sprite.play(anim)


func _is_between(check_val: float, min_v: float, max_v: float) -> bool:
	return (check_val >= min_v and check_val <= max_v)
