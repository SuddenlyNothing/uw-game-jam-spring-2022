class_name EnemyStrafe
extends EnemyAggro

export(int) var steering := 10
export(int) var min_dist := 300
export(int) var max_dist := 500

var desired_dir: Vector2

onready var min_dist_sqr := pow(min_dist, 2)
onready var max_dist_sqr := pow(max_dist, 2)

### Anims needed:
### idle
### death
### knockback
### move


func set_move_props() -> void:
	var dist_to_player := position.distance_to(player.position)
	if dist_to_player < min_dist_sqr:
		desired_dir = player.position.direction_to(position)
	elif dist_to_player > max_dist_sqr:
		desired_dir = position.direction_to(player.position)
	elif move_dir == null:
		desired_dir = Vector2.RIGHT.rotated(randf() * 2 * PI)
	else:
		desired_dir = desired_dir.rotated((randf() - 0.5) * PI / 4)
	if move_dir == null:
		move_dir = Vector2()
	move_dir = lerp(move_dir, desired_dir, clamp(steering * get_physics_process_delta_time(), 0, 1))
