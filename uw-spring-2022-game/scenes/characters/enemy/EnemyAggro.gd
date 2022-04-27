class_name EnemyAggro
extends EnemyMove

var player: Node setget set_player
var check_player := false

onready var vision_cast := $VisionCast
onready var vision := $Pivot/Vision

### Anims needed:
### idle
### death
### knockback
### move


func _physics_process(delta: float) -> void:
	if check_player:
		vision_cast.cast_to = player.position - position
		vision_cast.force_raycast_update()
		if vision_cast.is_colliding() and vision_cast.get_collider().is_in_group("player"):
			set_move_props()
		else:
			clear_move_props()


func set_player(val: Node) -> void:
	player = val
	if val == null:
		clear_move_props()


func set_move_props() -> void:
	if player == null:
		return
	move_dir = position.direction_to(player.position)
	face_pos = player.position


func clear_move_props() -> void:
	move_dir = null
	face_pos = null


func set_collision_disabled(val: bool) -> void:
	vision.call_deferred("set_disabled", val)
	.set_collision_disabled(val)


func _on_Vision_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	set_player(body)
	check_player = true


func _on_Vision_body_exited(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	set_player(null)
	check_player = false
