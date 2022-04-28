class_name EnemyMelee
extends EnemyAggro

export(int) var attack_frame := 0
export(int) var damage := 1

onready var hitbox := $Pivot/Hitbox
onready var attack_pos := $Pivot/AttackPos

### Anims needed:
### idle
### death
### knockback
### move
### attack +


func attack() -> void:
	for body in hitbox.get_overlapping_bodies():
		if not body.is_in_group("player"):
			return
		body.hit(damage, pivot.scale)


func is_player_in_hitbox() -> bool:
	if player == null:
		return false
	return player in hitbox.get_overlapping_bodies()


func set_move_props() -> void:
	move_dir = attack_pos.global_position.direction_to(player.position)
	face_pos = player.position


func set_collision_disabled(val: bool) -> void:
	hitbox.call_deferred("set_disabled", val)
	.set_collision_disabled(val)


func _on_AnimatedSprite_frame_changed() -> void:
	match anim_sprite.animation:
		"attack":
			match anim_sprite.frame:
				attack_frame:
					attack()


func _on_AnimatedSprite_animation_finished() -> void:
	if anim_sprite.animation == "attack":
		enemy_states.call_deferred("set_state", "idle")
	._on_AnimatedSprite_animation_finished()
