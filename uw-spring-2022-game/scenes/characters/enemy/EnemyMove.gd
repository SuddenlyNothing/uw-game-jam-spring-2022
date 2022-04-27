class_name EnemyMove
extends EnemyKnockback

export(int) var move_speed

var target_dir
var face_pos

### Anims needed:
### idle
### death
### knockback
### move +


func move() -> void:
	move_and_slide(move_speed * target_dir)
	set_facing(face_pos)
